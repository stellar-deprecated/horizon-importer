account :usd_gateway, FactoryGirl.create(:usd_gateway_key_pair)
account :scott,  FactoryGirl.create(:scott_key_pair)
account :andrew, FactoryGirl.create(:andrew_key_pair)

payment :master, :usd_gateway,  [:native, 1000_000000]
payment :master, :scott,        [:native, 1000_000000]
payment :master, :andrew,       [:native, 1000_000000]

close_ledger

trust :scott,  :usd_gateway, "USD"
trust :andrew, :usd_gateway, "USD"

close_ledger

payment :usd_gateway, :scott,  ["USD", :usd_gateway, 1000_000000]

close_ledger

payment :scott, :andrew, ["USD", :usd_gateway, 500_000000]
