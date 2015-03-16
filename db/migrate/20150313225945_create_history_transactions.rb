class CreateHistoryTransactions < ActiveRecord::Migration
  def change
    create_table :history_transactions do |t|
      # keys
      t.string  :transaction_hash,  limit: 64, null: false 
      t.integer :ledger_sequence,   null: false
      t.integer :application_order, null: false
      t.string  :account,           limit: 64, null: false
      t.integer :account_sequence,  null: false

      # attributes
      t.integer :max_fee,         null: false
      t.integer :fee_paid,        null: false
      t.integer :operation_count, null: false

      t.integer :transaction_status_id, null: false

      t.timestamps

      t.index [:transaction_hash],                    name: "by_hash"
      t.index [:ledger_sequence, :application_order], name: "by_ledger"
      t.index [:account, :account_sequence],          name: "by_account"
      t.index :transaction_status_id,                 name: "by_status"
    end

    create_table :history_transaction_statuses, low_card: true do |t|
      t.string  :result_code_s, null: false
      t.integer :result_code,   null: false
    end
  end
end
