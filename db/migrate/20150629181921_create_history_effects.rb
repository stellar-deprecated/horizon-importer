class CreateHistoryEffects < ActiveRecord::Migration
  def change
    create_table :history_effects, id: false do |t|
      t.integer :history_account_id, limit: 8, null: false
      t.integer :history_operation_id, limit: 8, null: false
      t.integer :order, null: false

      t.integer :type, null: false
      t.jsonb :details


      t.index [:history_account_id, :history_operation_id, :order],
        unique: true,
        name: "hist_e_id"

      t.index [:history_operation_id, :order],
        unique: true,
        name: "hist_e_by_order"

      t.index :type
    end
  end
end
