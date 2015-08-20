class AddTxResultToHistoryTransactions < ActiveRecord::Migration
  def change
    add_column :history_transactions, :txresult, :string
  end
end
