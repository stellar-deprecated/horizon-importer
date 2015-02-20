class CreatePendingTransactions < ActiveRecord::Migration
  def change
    create_table :pending_transactions do |t|
      t.integer   :state, default: 0, null: false

      t.string    :sending_address,  limit: 64, null: false

      t.integer   :sending_sequence,    limit: 4,  null: false
      t.integer   :max_ledger_sequence, limit: 8
      t.integer   :min_ledger_sequence, limit: 8

      t.text      :tx_envelope, limit: 4.kilobytes, null: false
      t.string    :tx_hash,     limit: 64,          null: false

      t.timestamps

      t.index :state
      t.index [:sending_address, :sending_sequence], :name => "by_sequence"
    end
  end
end
