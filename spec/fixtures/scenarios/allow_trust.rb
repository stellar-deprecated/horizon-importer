require 'factory_girl'
FactoryGirl.find_definitions

use_manual_close

account :usd_gateway, FactoryGirl.create(:usd_gateway_key_pair)
account :scott,       FactoryGirl.create(:scott_key_pair)
account :andrew,      FactoryGirl.create(:andrew_key_pair)

create_account :usd_gateway
create_account :scott
create_account :andrew

close_ledger

require_trust_auth :usd_gateway
set_flags :usd_gateway, [:auth_revocable_flag]

close_ledger

trust :scott,  :usd_gateway, "USD"
change_trust :andrew, :usd_gateway, "USD", 4000

close_ledger

allow_trust :usd_gateway, :scott, "USD"
allow_trust :usd_gateway, :andrew, "USD"

close_ledger

revoke_trust :usd_gateway, :andrew, "USD"
