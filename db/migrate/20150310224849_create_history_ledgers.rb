class CreateHistoryLedgers < ActiveRecord::Migration
  def change
    create_table :history_ledgers do |t|
      t.integer   :sequence, null: false
      t.string    :ledger_hash, limit: 64, null: false
      t.string    :previous_ledger_hash, limit: 64
      t.integer   :transaction_count, default: 0, null: false
      t.integer   :operation_count, default: 0, null: false
      t.datetime  :closed_at, null: false
      t.timestamps

      t.index :sequence, unique: true
      t.index :ledger_hash, unique: true
      t.index :previous_ledger_hash, unique: true
      t.index :closed_at
    end
  end
end
