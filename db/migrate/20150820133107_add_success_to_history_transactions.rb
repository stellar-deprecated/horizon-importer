class AddSuccessToHistoryTransactions < ActiveRecord::Migration
  def change
    add_column :history_transactions, :success, :bool
  end
end
