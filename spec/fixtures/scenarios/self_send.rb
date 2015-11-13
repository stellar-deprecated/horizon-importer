require 'factory_girl'
FactoryGirl.find_definitions

use_manual_close

account :scott,  FactoryGirl.create(:scott_key_pair)

create_account :scott,  :master, 100

close_ledger

payment :scott, :scott,  [:native, 5]
