require 'factory_girl'
FactoryGirl.find_definitions

use_manual_close
account :scott,  FactoryGirl.create(:scott_key_pair)

create_account :scott,  :master, 2_000_000_000 

close_ledger

set_inflation_dest :master, :master
set_inflation_dest :scott, :scott
inflation
