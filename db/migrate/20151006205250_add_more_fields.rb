class AddMoreFields < ActiveRecord::Migration
  def change
    change_table :history_operations do |t|
      t.string :source_account, limit: 64, null: false, default: ""
    end 

    change_table :history_transactions do |t|
      t.string :signatures, limit: 96, array: true, null: false, default: []
      t.string :memo_type, null: false, default: "none"
      t.string :memo
      t.int8range :time_bounds
    end 
  end
end
