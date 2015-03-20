Rails.application.config.after_initialize do
  if ENV["IMPORT_HISTORY"] == "true"
    History::LedgerPoller.supervise_as :ledger_poller
  end
end