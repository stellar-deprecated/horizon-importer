# 
# Takes the ledger header and transaction set of the requested sequence from the 
# hayashi database and imports them into the history database.
# 
class History::LedgerImporterJob < ApplicationJob
  EMPTY_HASH = "0" * 64

  def perform(ledger_sequence)
    hayashi_ledger, hayashi_transactions = load_hayashi_data(ledger_sequence)

    if hayashi_ledger.blank?
      raise ActiveRecord::RecordNotFound, 
        "Couldn't find ledger #{ledger_sequence}"
    end

    with_db(:history) do
      first_ledger = hayashi_ledger.ledgerseq == 1

      History::Base.transaction do
        # ensure we've imported the previous header
        unless first_ledger
          History::Ledger.validate_previous_ledger_hash!(hayashi_ledger.prevhash, hayashi_ledger.ledgerseq)
        end

        #TODO: don't error out when uniqueness validation fails, 
        # instead emit a warning with the error summary
        result = History::Ledger.create!({
          sequence:             hayashi_ledger.ledgerseq,
          ledger_hash:          hayashi_ledger.ledgerhash,
          previous_ledger_hash: (hayashi_ledger.prevhash unless first_ledger),
          closed_at:            Time.at(hayashi_ledger.closetime),
        })
        
        hayashi_transactions.each do |htx|
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
        end
        
        result
      end
    end
  end

  def load_hayashi_data(ledger_sequence)
    with_db(:hayashi) do
      ledger = Hayashi::LedgerHeader.at_sequence(ledger_sequence)
      
      [ledger, (ledger.transactions.to_a if ledger)]
    end
  end
end
