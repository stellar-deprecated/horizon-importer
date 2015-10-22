class RemoveMaxFee < ActiveRecord::Migration
  def change
    remove_column :history_transactions, :max_fee, :integer
  end
end
