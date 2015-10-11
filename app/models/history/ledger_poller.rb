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
    after(1.second){ current_actor.async.tick }
  end

  def tick
    History::LedgerCheckerJob.new.perform
  ensure
    after(1.second){ current_actor.async.tick }
  end
end
