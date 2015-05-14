account :usd_gateway, FactoryGirl.create(:usd_gateway_key_pair)
account :scott,  FactoryGirl.create(:scott_key_pair)
account :andrew, FactoryGirl.create(:andrew_key_pair)

create_account :scott,       :master, 1000_000000
create_account :usd_gateway, :master, 1000_000000
create_account :andrew,      :master, 1000_000000

close_ledger

trust :scott,  :usd_gateway, "USD"
trust :andrew, :usd_gateway, "USD"

close_ledger

payment :usd_gateway, :scott,  ["USD", :usd_gateway, 1000_000000]

close_ledger

payment :scott, :andrew, ["USD", :usd_gateway, 500_000000]
