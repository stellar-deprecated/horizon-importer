class AddSequenceSlotToPendingTransaction < ActiveRecord::Migration
  def change
    change_table :pending_transactions do |t|
      t.integer :sending_sequence_slot, limit: 4,  null: false
    end

  end
end
