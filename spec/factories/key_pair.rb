FactoryGirl.define do


  factory :key_pair, class: Stellar::KeyPair do
    sequence(:seed) {|n| n }
    initialize_with { Stellar::KeyPair.from_raw_seed(seed.to_s.ljust(32)) }

    skip_create
  end

  factory :master_key_pair, parent: :key_pair do
    seed "masterpassphrasemasterpassphrase"
  end
end