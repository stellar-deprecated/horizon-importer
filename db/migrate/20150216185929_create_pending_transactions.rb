class CreatePendingTransactions < ActiveRecord::Migration
  def change
    create_table :pending_transactions do |t|
      t.integer   :state, default: 0, null: false

      t.string    :sending_address, limit: 64, null: false
      t.integer   :sending_sequence, null: false
      
      t.integer   :max_ledger_sequence
      t.integer   :min_ledger_sequence

      t.text      :tx_envelope, null: false
      t.string    :tx_hash, null: false, limit: 64

      t.timestamps

      t.index :state
      t.index [:sending_address, :sending_sequence]
    end
  end
end
