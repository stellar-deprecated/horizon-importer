# 
# Timer that triggers History::LedgerCheckerJob when IMPORT_HISTORY
# mode is enabled.  Most of the interesting work is done in 
# `History::LedgerCheckerJob`
# 
# See config/initializers/ledger_poller.rb for where we setup this actor's
# supervisor
# 
class History::LedgerPoller
  include Celluloid

  def initialize
    every(1.second){ History::LedgerCheckerJob.new.async.perform }
  end
end