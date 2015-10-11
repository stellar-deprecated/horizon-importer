class ImporterIndexes < ActiveRecord::Migration
  def change
    add_index :history_accounts, :address, unique:true
  end
end
