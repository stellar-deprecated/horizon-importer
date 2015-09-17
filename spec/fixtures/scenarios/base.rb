require 'factory_girl'
FactoryGirl.find_definitions

use_manual_close


account :scott,  FactoryGirl.create(:scott_key_pair)
account :bartek, FactoryGirl.create(:bartek_key_pair)
account :andrew, FactoryGirl.create(:andrew_key_pair)

create_account :scott,  :master, 100
create_account :bartek, :master, 100
create_account :andrew, :master, 100

close_ledger

payment :scott, :andrew,  [:native, 5]
