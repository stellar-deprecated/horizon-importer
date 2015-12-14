require 'factory_girl'
FactoryGirl.find_definitions

use_manual_close

account :usd_gateway, FactoryGirl.create(:usd_gateway_key_pair)
account :scott,  FactoryGirl.create(:scott_key_pair)

create_account :usd_gateway,  :master, 100
create_account :scott,  :master, 100

close_ledger

trust :scott,  :usd_gateway, "USD"

close_ledger

payment :usd_gateway, :scott, ["USD", :usd_gateway, 10_000_000]

close_ledger

payment :scott, :usd_gateway, ["USD", :usd_gateway, 10_000]
