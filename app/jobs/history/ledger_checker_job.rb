# 
# Looks to see if the hayashi database has the new ledger available based
# upon our latest imported ledger, triggering an import job if one is 
# available
# 
class History::LedgerCheckerJob < ApplicationJob
  def perform

    # NOTE: this job is just for following the network... we should have
    # a separate path for bulk-loading history and catchup
    
    with_db(:history) do 
      with_db(:hayashi) do 
        last_imported = History::Ledger.last_imported_ledger.try(:sequence) || 0
      
        # ensure the next ledger is in the hayashi db
        next_ledger = last_imported + 1
        hayashi_ledger = Hayashi::LedgerHeader.at_sequence(next_ledger)
        return if hayashi_ledger.blank?

        History::LedgerImporterJob.new.async.perform(next_ledger)
      end
    end
  end
end
