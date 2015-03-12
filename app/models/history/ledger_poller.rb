class History::LedgerPoller
  include Celluloid

  def initialize
    every(2.seconds){ History::LedgerCheckerJob.new.async.perform }
  end
end