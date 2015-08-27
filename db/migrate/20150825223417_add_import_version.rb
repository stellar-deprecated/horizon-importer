class AddImportVersion < ActiveRecord::Migration
  def change
    change_table :history_ledgers do |t|
      t.integer :importer_version, default: 1, null: false
      t.index :importer_version
    end
  end
end
