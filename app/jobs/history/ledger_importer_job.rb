#
# Takes the ledger header and transaction set of the requested sequence from the
# stellar_core database and imports them into the history database.
#
class History::LedgerImporterJob < ApplicationJob
  EMPTY_HASH = "0" * 64

  def perform(ledger_sequence)
    stellar_core_ledger, stellar_core_transactions = load_stellar_core_data(ledger_sequence)

    if stellar_core_ledger.blank?
      raise ActiveRecord::RecordNotFound,
        "Couldn't find ledger #{ledger_sequence}"
    end

    with_db(:history) do
      first_ledger = stellar_core_ledger.ledgerseq == 1

      create_master_history_account! if first_ledger

      History::Base.transaction do
        # ensure we've imported the previous header
        unless first_ledger
          History::Ledger.validate_previous_ledger_hash!(stellar_core_ledger.prevhash, stellar_core_ledger.ledgerseq)
        end

        #TODO: don't error out when uniqueness validation fails,
        # instead emit a warning with the error summary
        result = History::Ledger.create!({
          sequence:             stellar_core_ledger.ledgerseq,
          ledger_hash:          stellar_core_ledger.ledgerhash,
          previous_ledger_hash: (stellar_core_ledger.prevhash unless first_ledger),
          closed_at:            Time.at(stellar_core_ledger.closetime),
          transaction_count:    stellar_core_transactions.length,
          operation_count:      stellar_core_transactions.map(&:operation_count).sum
        })

        stellar_core_transactions.each do |sctx|
          htx   = import_history_transaction sctx
          haccs = import_history_accounts sctx
          hops  = import_history_operations sctx, htx
          heffs = import_history_effects sctx, hops
        end

        result
      end
    end
  end

  private

  def load_stellar_core_data(ledger_sequence)
    with_db(:stellar_core) do
      ledger = StellarCore::LedgerHeader.at_sequence(ledger_sequence)

      [ledger, (ledger.transactions.to_a if ledger)]
    end
  end

  def import_history_transaction(sctx)
    htx = History::Transaction.create!({
      transaction_hash:  sctx.txid,
      ledger_sequence:   sctx.ledgerseq,
      application_order: sctx.txindex,
      account:           sctx.submitting_address,
      account_sequence:  sctx.submitting_sequence,
      max_fee:           sctx.fee_paid,
      fee_paid:          sctx.fee_paid,
      operation_count:   sctx.operations.size,
      # TODO: uncomment when low card system is fixed
      txresult:          sctx.txresult,
      success:           sctx.success?,
      # result_code:       sctx.result_code.value,
      # result_code_s:     sctx.result_code_s,
      # TODO: remove the below when low card system is fixed
      transaction_status_id: -1,
    })

    sctx.participant_addresses.each do |addr|
      History::TransactionParticipant.create!({
        transaction_hash:  sctx.txid,
        account: addr
      })
    end

    htx
  end

  def import_history_accounts(sctx)
    haccs = []
    if !sctx.success? 
      return 
    end
    sctx.operations.each_with_index do |op, i|
      next unless op.body.type == Stellar::OperationType.create_account

      pop                 = op.body.value
      destination_pk      = pop.destination
      destination_address = Stellar::Convert.pk_to_address(destination_pk)
      id                  = TotalOrderId.make(sctx.ledgerseq, sctx.txindex, i)

      haccs << History::Account.create!(address: destination_address, id: id)
    end

    haccs
  end

  def import_history_operations(sctx, htx)
    hops = []

    sctx.operations_with_results.each_with_index do |op_and_r, application_order|
      op, result = *op_and_r

      source_account = op.source_account || sctx.source_account
      participant_addresses = [Stellar::Convert.pk_to_address(source_account)]

      hop = History::Operation.new({
        transaction_id:    htx.id,
        application_order: application_order,
        type:              op.body.type.value,
        details:           {},
      })


      case op.body.type
      when Stellar::OperationType.create_account
        op = op.body.create_account_op!
        participant_addresses << Stellar::Convert.pk_to_address(op.destination)

        hop.details = {
          "funder"           => Stellar::Convert.pk_to_address(source_account),
          "account"          => Stellar::Convert.pk_to_address(op.destination),
          "starting_balance" => op.starting_balance,
        }
      when Stellar::OperationType.payment
        payment = op.body.payment_op!

        hop.details = {
          "from"   => Stellar::Convert.pk_to_address(source_account),
          "to"     => Stellar::Convert.pk_to_address(payment.destination),
          "amount" => payment.amount,
        }
        hop.details.merge! asset_details(payment.asset)

        participant_addresses << hop.details["to"]

      when Stellar::OperationType.path_payment
        payment = op.body.path_payment_op!
        result = result.tr!.path_payment_result!

        hop.details = {
          "from"          => Stellar::Convert.pk_to_address(source_account),
          "to"            => Stellar::Convert.pk_to_address(payment.destination),
          "amount"        => payment.dest_amount,
          "source_amount" => result.send_amount
        }

        hop.details.merge! asset_details(payment.dest_asset)
        hop.details.merge! asset_details(payment.send_asset, "send_")

        participant_addresses << hop.details["to"]
      when Stellar::OperationType.manage_offer
        offer = op.body.manage_offer_op!

        hop.details = {
          "offer_id" => offer.offer_id,
          "amount"   => offer.amount,
          "price"    => {
            "n" => offer.price.n,
            "d" => offer.price.d,
          }
        }

        #TODO
        # import into history api:
        #   - order book info

        # import into an trading API
        #   TODO

      when Stellar::OperationType.create_passive_offer
        offer = op.body.create_passive_offer_op!

        hop.details = {
          "amount"    => offer.amount,
          "price"     => {
            "n" => offer.price.n,
            "d" => offer.price.d,
          }
        }

        #TODO
        # import into history api:
        #   - order book info


      when Stellar::OperationType.set_options
        sop = op.body.set_options_op!
        hop.details = {}

        if sop.inflation_dest.present?
          hop.details["inflation_dest"] = Stellar::Convert.pk_to_address(sop.inflation_dest)
        end

        #TODO: set/clear flags
        parsed = Stellar::AccountFlags.parse_mask(sop.set_flags || 0)
        if parsed.any?
          hop.details["set_flags"] = parsed.map(&:value)
          hop.details["set_flags_s"] = parsed.map(&:name)
        end

        parsed = Stellar::AccountFlags.parse_mask(sop.clear_flags || 0)
        if parsed.any?
          hop.details["clear_flags"] = parsed.map(&:value)
          hop.details["clear_flags_s"] = parsed.map(&:name)
        end

        if sop.master_weight.present?
          hop.details["master_key_weight"] = sop.master_weight
        end

        if sop.low_threshold.present?
          hop.details["low_threshold"]     = sop.low_threshold
        end

        if sop.med_threshold.present?
          hop.details["med_threshold"]  = sop.med_threshold
        end

        if sop.high_threshold.present?
          hop.details["high_threshold"]    = sop.high_threshold
        end

        if sop.home_domain.present?
          hop.details["home_domain"] = sop.home_domain
        end

        if sop.signer.present?
          hop.details.merge!({
            "signer_key"    => Stellar::Convert.pk_to_address(sop.signer.pub_key),
            "signer_weight" => sop.signer.weight,
          })
        end

      when Stellar::OperationType.change_trust
        ctop        = op.body.change_trust_op!
        asset    = ctop.line

        hop.details = {
          "trustor" => Stellar::Convert.pk_to_address(source_account),
          "limit"   => ctop.limit
        }
        hop.details.merge! asset_details(asset)
        hop.details["trustee"] = hop.details["asset_issuer"]

        if asset.type == Stellar::AssetType.asset_type_native
          raise "native asset in change_trust_op"
        end

      when Stellar::OperationType.allow_trust
        atop  = op.body.allow_trust_op!
        asset = atop.asset

        hop.details = {
          "trustee"         => Stellar::Convert.pk_to_address(source_account),
          "trustor"         => Stellar::Convert.pk_to_address(atop.trustor),
          "authorize"       => atop.authorize
        }

        case asset.type
        when Stellar::AssetType.asset_type_native
          raise "native asset in allow_trust_op"
        when Stellar::AssetType.asset_type_credit_alphanum4
          hop.details["asset_type"]   = "credit_alphanum4"
          hop.details["asset_code"]   = asset.asset_code4!.strip
          hop.details["asset_issuer"] = Stellar::Convert.pk_to_address source_account
        when Stellar::AssetType.asset_type_credit_alphanum12
          hop.details["asset_type"]   = "credit_alphanum12"
          hop.details["asset_code"]   = asset.asset_code12!.strip
          hop.details["asset_issuer"] = Stellar::Convert.pk_to_address source_account
        else
          raise "Unknown asset type: #{asset.type}"
        end

      when Stellar::OperationType.account_merge
        destination  = op.body.destination!
        hop.details = {
          "account"   => Stellar::Convert.pk_to_address(source_account),
          "into"     => Stellar::Convert.pk_to_address(destination)
        }
        participant_addresses << hop.details["into"]
      when Stellar::OperationType.inflation
        #Inflation has no details, presently.
      end


      hop.save!
      hops << hop

      participant_addresses.uniq!
      # now import the participants from this operation
      participants = History::Account.where(address:participant_addresses).all

      unless participants.length == participant_addresses.length
        raise "Could not find all participants"
      end

      participants.each do |account|
        History::OperationParticipant.create!({
          history_account:   account,
          history_operation: hop,
        })
      end
    end

    hops
  end

  def import_history_effects(sctx, hops)
    heffs = []

    sctx.operations_with_results.each_with_index do |op_and_r, application_order|
      scop, scresult = *op_and_r
      hop = hops[application_order]

      heffs.concat import_history_effects_for_operation(sctx, scop, scresult, hop)
    end

    heffs
  end

  def import_history_effects_for_operation(sctx, scop, scresult, hop)
    effects = History::EffectFactory.new(hop)
    source_account = scop.source_account || sctx.source_account

    case hop.type_as_enum
    when Stellar::OperationType.create_account
      scop = scop.body.create_account_op!

      effects.create!("account_created", scop.destination, {
        starting_balance: scop.starting_balance,
      })

      effects.create!("account_debited", source_account, {
        asset_type: "native",
        amount: scop.starting_balance
      })

    when Stellar::OperationType.payment
      scop = scop.body.payment_op!
      details = { amount: scop.amount }
      details.merge!  asset_details(scop.asset)
      effects.create!("account_credited", scop.destination, details)
      effects.create!("account_debited", source_account, details)
    when Stellar::OperationType.path_payment
      scop = scop.body.path_payment_op!

      dest_details = { amount: scop.dest_amount }
      dest_details.merge!  asset_details(scop.dest_asset)
      effects.create!("account_credited", scop.destination, dest_details)

      scresult = scresult.tr!.path_payment_result!
      source_details = { amount: scresult.send_amount }
      source_details.merge!  asset_details(scop.send_asset)

      effects.create!("account_credited", scop.destination, dest_details)
      effects.create!("account_debited", source_account, source_details)
    when Stellar::OperationType.manage_offer
      # TODO
    when Stellar::OperationType.create_passive_offer
      # TODO
    when Stellar::OperationType.set_options
      scop = scop.body.set_options_op!
      # TODO: if signer present, add the signer* effects

      unless scop.home_domain.nil?
        effects.create!("account_home_domain_updated", source_account, {
          "home_domain" => scop.home_domain
        })
      end

      # unless scop.thresholds.nil?
      #   effects.create!("account_thresholds_updated", source_account, {
      #     # TODO: fill in details
      #   })
      #
      #   # TODO: import signer_* effects for master key
      # end

      unless scop.set_flags.nil? && scop.clear_flags.nil?
        effects.create!("account_flags_updated", source_account, {
          # TODO: fill in details
        })
      end

    when Stellar::OperationType.change_trust
      scop = scop.body.change_trust_op!
      effect = nil # if a trustline was added in the meta, use trustline_added
                   # if limit is 0, use trustline_removed
                   # otherwise trustline_updated

      # TODO
    when Stellar::OperationType.allow_trust
      scop = scop.body.allow_trust_op!
      asset = scop.asset
      effect = scop.authorize ? "trustline_authorized" : "trustline_deauthorized"
      details = {
        "trustor" => Stellar::Convert.pk_to_address(scop.trustor),
      }

      case asset.type
      when Stellar::AssetType.asset_type_native
        raise "native asset in allow_trust_op"
      when Stellar::AssetType.asset_type_credit_alphanum4
        details["asset_type"]   = "credit_alphanum4"
        details["asset_code"]   = asset.asset_code4!.strip
      when Stellar::AssetType.asset_type_credit_alphanum12
        details["asset_type"]   = "credit_alphanum12"
        details["asset_code"]   = asset.asset_code12!.strip
      else
        raise "Unknown asset type: #{asset.type}"
      end


      effects.create!(effect, source_account, details)
    when Stellar::OperationType.account_merge
      # TODO: account_debited on source account of remaining lumens in source_account
      # TODO: account_credited on destination of remaining lumens in source_account
      effects.create!("account_removed", source_account, source_details)
    when Stellar::OperationType.inflation
      payouts = scresult.tr!.inflation_result!.payouts!

      payouts.each do |payout|
        details = { amount: payout.amount, asset_type: "native" }
        effects.create!("account_credited", payout.destination, details)
      end
    else
      Rails.logger.info "Unknown type: #{hop.type_as_enum.name}.  skipping effects import"
    end

    effects.results
  end

  def asset_details(asset, prefix="")
    case asset.type
    when Stellar::AssetType.asset_type_native
      { "#{prefix}asset_type" => "native" }
    when Stellar::AssetType.asset_type_credit_alphanum4
      coded_asset_details(asset, prefix, "credit_alphanum4")
    when Stellar::AssetType.asset_type_credit_alphanum12
      coded_asset_details(asset, prefix, "credit_alphanum12")
    else
      raise "Unknown asset type: #{asset.type}"
    end
  end

  def coded_asset_details(asset, prefix, type)
    {
      "#{prefix}asset_type"   => type,
      "#{prefix}asset_code"   => asset.code.strip,
      "#{prefix}asset_issuer" => Stellar::Convert.pk_to_address(asset.issuer),
    }
  end

  #
  # This method ensures that we create the history_account record for the
  # master account, which is a special case because it never shows up as
  # a new account in some transaction's metadata.
  #
  def create_master_history_account!
    History::Account.create!(address: Stellar::KeyPair.master.address, id: 0)
  end
end
