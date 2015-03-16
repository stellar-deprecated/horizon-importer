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
        History::Ledger.create!({
          sequence:             hayashi_ledger.ledgerseq,
          ledger_hash:          hayashi_ledger.ledgerhash,
          previous_ledger_hash: (hayashi_ledger.prevhash unless first_ledger),
          closed_at:            Time.at(hayashi_ledger.closetime),
        })

        #TODO: import all transactions from the imported ledger
        
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
