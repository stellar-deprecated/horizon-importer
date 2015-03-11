class History::LedgerPoller
  include Celluloid

  def initialize
    every(2.seconds){ check_for_new_ledgers }
  end

  private
  def check_for_new_ledgers
    Hayashi::Base.connection_pool.with_connection do


    end

  end

  def last_closed_ledger
    
  end

  def next_ledger_sequence
    
  end
end