# 
# Takes the ledger header and transaction set of the requested sequence from the 
# hayashi database and imports them into the history database.
# 
class History::LedgerImporterJob < ApplicationJob
  EMPTY_HASH = "0" * 64

  def perform(ledger_sequence)
    hayashi_ledger = with_db(:hayashi) do
      Hayashi::LedgerHeader.at_sequence(ledger_sequence)
    end

    raise ActiveRecord::RecordNotFound if hayashi_ledger.blank?

    with_db(:history) do
      first_ledger = hayashi_ledger.ledgerseq == 1

      History::Base.transaction do
        # ensure we've imported the previous header
        unless first_ledger
          History::Ledger.validate_previous_ledger_hash!(hayashi_ledger.prevhash, hayashi_ledger.ledgerseq)
        end

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
end
