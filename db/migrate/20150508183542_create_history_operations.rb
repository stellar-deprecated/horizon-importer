class CreateHistoryOperations < ActiveRecord::Migration
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :history_operations, id: false do |t|
      t.integer :id, limit: 8, null: false

      t.integer :transaction_id, limit: 8, null: false
      t.integer :application_order, null: false

      t.integer :type, null: false
      t.hstore :details

      t.index :id, unique: true
      t.index :transaction_id
      t.index :type
    end
  end
end
