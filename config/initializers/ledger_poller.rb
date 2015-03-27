def setup_poller
  if ENV["IMPORT_HISTORY"] == "true"
    History::LedgerPoller.supervise_as :ledger_poller
  end
end

if Rails.configuration.cache_classes
  setup_poller
else
  ActionDispatch::Reloader.to_prepare do
    setup_poller
  end

  ActionDispatch::Reloader.to_cleanup do
    $ledger_poller.terminate if $ledger_poller
  end
end