class RenameOrderToId < ActiveRecord::Migration
  def change    
    rename_column :history_ledgers,      :order, :id
    rename_column :history_transactions, :order, :id
    
    add_index :history_ledgers, :id, unique: true, name: "hs_ledger_by_id"
    add_index :history_transactions, :id, unique: true, name: "hs_transaction_by_id"
  end
end
