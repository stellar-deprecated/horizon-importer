class RemoveSequenceSlotFromPendingTransaction < ActiveRecord::Migration
  def change
    change_table :pending_transactions do |t|
      t.remove :sending_sequence_slot
    end
  end
end
