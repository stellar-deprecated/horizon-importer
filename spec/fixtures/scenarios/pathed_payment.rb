account :usd_gateway, FactoryGirl.create(:usd_gateway_key_pair)
account :eur_gateway, FactoryGirl.create(:eur_gateway_key_pair)
account :scott,  FactoryGirl.create(:scott_key_pair)
account :andrew, FactoryGirl.create(:andrew_key_pair)
account :bartek, FactoryGirl.create(:bartek_key_pair)


payment :master, :usd_gateway, [:native, 1000_000000]
payment :master, :eur_gateway, [:native, 1000_000000]

payment :master, :scott, [:native, 1000_000000]
payment :master, :bartek, [:native, 1000_000000]
payment :master, :andrew, [:native, 1000_000000]

close_ledger

trust :scott,  :usd_gateway, "USD"
trust :bartek, :eur_gateway, "EUR"
trust :andrew, :usd_gateway, "USD"
trust :andrew, :eur_gateway, "EUR"

close_ledger

payment :usd_gateway, :scott,  ["USD", :usd_gateway, 1000_000000]
payment :usd_gateway, :andrew, ["USD", :usd_gateway, 200_000000]
payment :eur_gateway, :andrew, ["EUR", :eur_gateway, 200_000000]
payment :eur_gateway, :bartek, ["EUR", :eur_gateway, 1000_000000]

close_ledger

offer :andrew, {buy:["USD", :usd_gateway], with:["EUR", :eur_gateway]}, 200_000000, 1.0

close_ledger

payment :scott, :bartek, ["EUR", :eur_gateway, 10], path: [["USD", :usd_gateway]]

