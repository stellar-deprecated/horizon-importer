class TradesIndex < ActiveRecord::Migration
  def up
    trade_type = History::Effect::BY_NAME["trade"]

    execute <<-SQL
      CREATE INDEX trade_effects_by_order_book 
      ON history_effects (
        (details->>'sold_asset_type'),
        (details->>'sold_asset_code'),
        (details->>'sold_asset_issuer'),
        (details->>'bought_asset_type'),
        (details->>'bought_asset_code'),
        (details->>'bought_asset_issuer')
      )
      WHERE type = #{trade_type} 
    SQL
  end

  def down
    execute "DROP INDEX trade_effects_by_order_book "
  end
end
