class AddLedgerFields < ActiveRecord::Migration
  def change
    change_table :history_ledgers do |t|
      t.integer :total_coins, limit: 8
      t.integer :fee_pool, limit: 8
      t.integer :base_fee
      t.integer :base_reserve
      t.integer :max_tx_set_size
    end 
  end
end
