account :scott,  FactoryGirl.create(:scott_key_pair)
account :bartek, FactoryGirl.create(:bartek_key_pair)
account :andrew, FactoryGirl.create(:andrew_key_pair)

payment :master, :scott,  [:native, 1000_000000]
payment :master, :bartek, [:native, 1000_000000]
payment :master, :andrew, [:native, 1000_000000]

close_ledger

payment :scott, :andrew,  [:native, 50_000000]