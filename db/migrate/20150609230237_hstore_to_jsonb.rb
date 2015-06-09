class HstoreToJsonb < ActiveRecord::Migration
  def change
    change_table :history_operations do |t|
      t.remove :details
      t.jsonb :details
    end
  end
end
