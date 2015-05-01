class AddOrder < ActiveRecord::Migration
  def change
    add_column :history_ledgers, :order, :integer, limit:8
    add_column :history_transactions, :order, :integer, limit:8

    add_index :history_ledgers, :order, unique: true
    add_index :history_transactions, :order, unique: true

    remove_column :history_ledgers, :id
    remove_column :history_transactions, :id
  end
end
