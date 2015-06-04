require 'factory_girl'
FactoryGirl.find_definitions

use_manual_close

account :scott,  FactoryGirl.create(:scott_key_pair)
account :bartek, FactoryGirl.create(:bartek_key_pair)

create_account :scott,  :master
create_account :bartek, :master

close_ledger

merge_account :scott, :bartek
