class CreateHistoryOperationParticipants < ActiveRecord::Migration
  def change
    create_table :history_operation_participants do |t|
      t.integer :history_operation_id, limit: 8, null: false
      t.integer :history_account_id, limit: 8, null: false

      t.index [:history_account_id, :history_operation_id], 
        name: "hist_op_p_id",
        unique: true
    end
  end
end
