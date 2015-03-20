class CreateHistoryTransactionParticipants < ActiveRecord::Migration
  def change
    create_table :history_transaction_participants do |t|
      t.string :transaction_hash, limit: 64, null: false
      t.string :account,          limit: 64, null: false
      t.timestamps

      t.index [:account]
      t.index [:transaction_hash]
    end
  end
end
