require 'factory_girl'
FactoryGirl.find_definitions

use_manual_close

account :usd_gateway, FactoryGirl.create(:usd_gateway_key_pair)
account :scott,       FactoryGirl.create(:scott_key_pair)

create_account :usd_gateway
create_account :scott

close_ledger

trust :scott, :usd_gateway, "USD"              ; close_ledger
change_trust :scott, :usd_gateway, "USD", 4000 ; close_ledger
change_trust :scott, :usd_gateway, "USD", 0    ; close_ledger
