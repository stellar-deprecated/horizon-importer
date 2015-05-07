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
        
        stellar_core_transactions.each do |htx|
          History::Transaction.create!({
            transaction_hash:  htx.txid, 
            ledger_sequence:   htx.ledgerseq,
            application_order: htx.txindex,
            account:           htx.submitting_address,
            account_sequence:  htx.submitting_sequence,
            max_fee:           htx.max_fee,
            fee_paid:          htx.fee_paid,
            operation_count:   htx.operations.size,
            # TODO: uncomment when low card system is fixed
            # result_code:       htx.result_code.value,
            # result_code_s:     htx.result_code_s,
            # TODO: remove the below when low card system is fixed
            transaction_status_id: -1,
          })

          htx.participant_addresses.each do |addr|
            History::TransactionParticipant.create!({
              transaction_hash:  htx.txid,
              account: addr
            })
          end
        end
        
        result
      end
    end
  end

  def load_stellar_core_data(ledger_sequence)
    with_db(:stellar_core) do
      ledger = StellarCore::LedgerHeader.at_sequence(ledger_sequence)
      
      [ledger, (ledger.transactions.to_a if ledger)]
    end
  end
end
