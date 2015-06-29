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
          next unless sctx.success?

          htx   = import_history_transaction sctx
          haccs = import_history_accounts sctx
          hops  = import_history_operations sctx, htx
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

    sctx.operations.each_with_index do |op, i|
      next unless op.body.type == Stellar::OperationType.create_account

      pop                 = op.body.value
      destination_pk      = pop.destination
      destination_address = Convert.pk_to_address(destination_pk)
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
      participant_addresses = [Convert.pk_to_address(source_account)]

      hop = History::Operation.new({
        transaction_id:    htx.id,
        application_order: application_order,
        type:              op.body.type.value,
      })


      case op.body.type
      when Stellar::OperationType.create_account
        op = op.body.create_account_op!
        participant_addresses << Convert.pk_to_address(op.destination)

        hop.details = {
          "funder"           => Convert.pk_to_address(source_account),
          "account"          => Convert.pk_to_address(op.destination),
          "starting_balance" => op.starting_balance,
        }
      when Stellar::OperationType.payment
        payment = op.body.payment_op!

        hop.details = {
          "from"   => Convert.pk_to_address(source_account),
          "to"     => Convert.pk_to_address(payment.destination),
          "amount" => payment.amount,
        }

        participant_addresses << hop.details["to"]

        case payment.currency.type
        when Stellar::CurrencyType.currency_type_native
          hop.details["currency_type"] = "native"
        when Stellar::CurrencyType.currency_type_alphanum
          an = payment.currency.alpha_num!
          hop.details["currency_type"]   = "alphanum"
          hop.details["currency_code"]   = an.currency_code.strip
          hop.details["currency_issuer"] = Convert.pk_to_address an.issuer
        else
          raise "Unknown currency type: #{payment.currency.type}"
        end
      when Stellar::OperationType.path_payment
        payment = op.body.path_payment_op!

        hop.details = {
          "from"   => Convert.pk_to_address(source_account),
          "to"     => Convert.pk_to_address(payment.destination),
          "amount" => payment.dest_amount,
        }

        participant_addresses << hop.details["to"]

        case payment.dest_currency.type
        when Stellar::CurrencyType.currency_type_native
          hop.details["currency_type"] = "native"
        when Stellar::CurrencyType.currency_type_alphanum
          an = payment.dest_currency.alpha_num!
          hop.details["currency_type"]   = "alphanum"
          hop.details["currency_code"]   = an.currency_code.strip
          hop.details["currency_issuer"] = Convert.pk_to_address an.issuer
        else
          raise "Unknown currency type: #{payment.dest_currency.type}"
        end

        # TODO: calculate source cost when ClaimOfferAtom

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
          hop.details["inflation_dest"] = Convert.pk_to_address(sop.inflation_dest)
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

        if sop.thresholds.present?
          parsed = Stellar::Thresholds.parse(sop.thresholds)

          hop.details.merge!({
            "master_key_weight" => parsed[:master_weight],
            "low_threshold"     => parsed[:low],
            "medium_threshold"  => parsed[:medium],
            "high_threshold"    => parsed[:high],
          })
        end

        if sop.home_domain.present?
          hop.details["home_domain"] = sop.home_domain
        end

        if sop.signer.present?
          hop.details.merge!({
            "signer_key"    => Convert.pk_to_address(sop.signer.pub_key),
            "signer_weight" => sop.signer.weight,
          })
        end

      when Stellar::OperationType.change_trust
        ctop        = op.body.change_trust_op!
        currency    = ctop.line

        hop.details = {
          "trustor" => Convert.pk_to_address(source_account),
          "limit"   => ctop.limit
        }

        case currency.type
        when Stellar::CurrencyType.currency_type_native
          raise "native currency in change_trust_op"
        when Stellar::CurrencyType.currency_type_alphanum
          an = currency.alpha_num!
          hop.details["currency_type"]   = "alphanum"
          hop.details["currency_code"]   = an.currency_code.strip
          hop.details["currency_issuer"] = Convert.pk_to_address an.issuer
          hop.details["trustee"]         = Convert.pk_to_address an.issuer
        else
          raise "Unknown currency type: #{currency.type}"
        end

      when Stellar::OperationType.allow_trust
        atop        = op.body.allow_trust_op!
        currency    = atop.currency

        hop.details = {
          "trustee"         => Convert.pk_to_address(source_account),
          "trustor"         => Convert.pk_to_address(atop.trustor),
          "authorize"       => atop.authorize
        }

        case currency.type
        when Stellar::CurrencyType.currency_type_native
          raise "native currency in allow_trust_op"
        when Stellar::CurrencyType.currency_type_alphanum
          hop.details["currency_type"]   = "alphanum"
          hop.details["currency_code"]   = currency.currency_code!.strip
          hop.details["currency_issuer"] = Convert.pk_to_address source_account
        else
          raise "Unknown currency type: #{currency.type}"
        end
      when Stellar::OperationType.account_merge
        destination  = op.body.destination!
        hop.details = {
          "account"   => Convert.pk_to_address(source_account),
          "into"     => Convert.pk_to_address(destination)
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
  end

  #
  # This method ensures that we create the history_account record for the
  # master account, which is a special case because it never shows up as
  # a new account in some transaction's metadata.
  #
  def create_master_history_account!
    master_key = Stellar::KeyPair.from_raw_seed "allmylifemyhearthasbeensearching"
    History::Account.create!(address: master_key.address, id: 0)
  end
end
