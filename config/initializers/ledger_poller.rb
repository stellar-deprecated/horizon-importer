class LedgerPollerRailtie < ::Rails::Railtie
  config.to_prepare do
    if ENV["IMPORT_HISTORY"] == "true"
      History::LedgerPoller.supervise_as :ledger_poller
    end
  end
end


unless Rails.configuration.cache_classes
  ActionDispatch::Reloader.to_cleanup do
    Celluloid::Actor[:ledger_poller].try :terminate
  end
end


Metriks.gauge("history.latest_ledger"){ History::Ledger.last_imported_ledger.sequence rescue -1 }
Metriks.gauge("stellar-core.latest_ledger"){ StellarCore::LedgerHeader.latest.sequence rescue -1 }