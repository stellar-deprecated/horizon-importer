require 'factory_girl'
FactoryGirl.find_definitions

use_manual_close

account :scott,  FactoryGirl.create(:scott_key_pair)
account :bartek, FactoryGirl.create(:bartek_key_pair)
create_account :scott
create_account :bartek

close_ledger

set_inflation_dest :scott, :bartek
set_flags :scott, [:auth_required_flag]
set_thresholds :scott, master_weight: 2, low: 0, medium: 2, high: 2
set_home_domain :scott, "nullstyle.com"
add_signer :scott, FactoryGirl.create(:usd_gateway_key_pair), 1

close_ledger

clear_flags :scott, [:auth_required_flag]
remove_signer :scott, FactoryGirl.create(:usd_gateway_key_pair)
