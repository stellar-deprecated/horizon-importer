# 
# Looks to see if the stellar core database has the new ledger available based
# upon our latest imported ledger, triggering an import job if one is 
# available
# 
class History::LedgerCheckerJob < ApplicationJob
  def perform

    # NOTE: this job is just for following the network... we should have
    # a separate path for bulk-loading history and catchup
    
    with_db(:history) do 
      with_db(:stellar_core) do 
        loop do
          last_imported = History::Ledger.last_imported_ledger.try(:sequence) || 0
        
          # ensure the next ledger is in the stellar_core db
          next_ledger = last_imported + 1
          core_ledger = StellarCore::LedgerHeader.at_sequence(next_ledger)
          return if core_ledger.blank?

          History::LedgerImporterJob.new.perform(next_ledger)
        end
      end
    end
  end
end
