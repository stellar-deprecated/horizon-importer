class CleanupHistoryTransactions < ActiveRecord::Migration
  def change

    # This migration requires a history rebuild, and assumes that your have cleared history.
    # run `rake db:clear_history` prior to running this migration

    change_column_null :history_transactions, :tx_envelope, false
    change_column_null :history_transactions, :tx_result, false
    change_column_null :history_transactions, :tx_meta, false
    remove_column :history_transactions, :transaction_status_id, :integer

    add_column :history_transactions, :tx_fee_meta, :text, null: false
  end
end
