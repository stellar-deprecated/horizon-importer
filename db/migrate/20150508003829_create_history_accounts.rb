class CreateHistoryAccounts < ActiveRecord::Migration
  def change
    create_table :history_accounts, id: false do |t|
      t.integer :id, limit: 8, null: false
      t.string :address, limit: 64
      t.index :id, unique: true
    end
  end
end
