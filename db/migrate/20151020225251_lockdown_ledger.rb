class LockdownLedger < ActiveRecord::Migration
  def change
    change_column_null :history_ledgers, :total_coins, false
    change_column_null :history_ledgers, :fee_pool, false
    change_column_null :history_ledgers, :base_fee, false
    change_column_null :history_ledgers, :base_reserve, false
    change_column_null :history_ledgers, :max_tx_set_size, false
  end
end
