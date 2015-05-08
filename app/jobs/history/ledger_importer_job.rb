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
      max_fee:           sctx.max_fee,
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

    addresses = sctx.
      live_participants.
      map{|pk| Convert.pk_to_address(pk)}

    existing_addresses = History::Account.
      where(address:addresses).
      pluck(:address)

    new_addresses = addresses - existing_addresses

    sctx.operations.each_with_index do |op, i|
      next unless op.body.type == Stellar::OperationType.payment

      pop                 = op.body.value
      destination_pk      = pop.destination
      destination_address = Convert.pk_to_address(destination_pk)

      next unless new_addresses.include? destination_address
      id = TotalOrderId.make(sctx.ledgerseq, sctx.txindex, i)

      # remove destination_address from new_addresses because
      # we're importing it now.  This prevents multiple imports
      # of the same account
      new_addresses.delete(destination_address)
      existing_addresses << destination_address

      haccs << History::Account.create!(address: destination_address, id: id)
    end

    haccs
  end

  def import_history_operations(sctx, htx)
    hops = []
    
    sctx.operations_with_results.each_with_index do |op_and_r, application_order|
      op, result = *op_and_r
    
      source_account = op.source_account || sctx.source_account
    
      hop = History::Operation.new({
        transaction_id:    htx.id,
        application_order: application_order,
        type:              op.body.type.value,
      })
    

      # TODO: fill in details here
      case op.body.type
      when Stellar::OperationType.payment
        payment = op.body.payment_op!

        hop.details = {
          from:          Convert.pk_to_address(source_account),
          to:            Convert.pk_to_address(payment.destination),
          amount:          payment.amount,
        }

        case payment.currency.type
        when Stellar::CurrencyType.native
          hop.details[:currency_code] = "XLM"
        when Stellar::CurrencyType.iso4217
          hop.details[:currency_code]   = payment.currency.iso_ci!.currency_code.strip
          hop.details[:currency_issuer] = Convert.pk_to_address payment.currency.iso_ci!.issuer
        else
          raise "Unknown currency type: #{payment.currency.type}"
        end 
      end
      
      hop.save!
      hops << hop
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
