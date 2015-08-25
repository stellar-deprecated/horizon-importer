class AddXdrColumns < ActiveRecord::Migration
  def change
    change_table :history_transactions do |t|
      t.text :tx_envelope
      t.text :tx_result
      t.text :tx_meta
    end
  end
end
