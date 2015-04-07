FactoryGirl.define do

  factory :key_pair, class: Stellar::KeyPair do
    sequence(:seed) {|n| n }
    initialize_with { Stellar::KeyPair.from_raw_seed(seed.to_s.ljust(32)) }

    skip_create
  end

  factory :master_key_pair, parent: :key_pair do
    seed "allmylifemyhearthasbeensearching"
  end

  factory(:scott_key_pair,        parent: :key_pair){ seed "scott" }
  factory(:andrew_key_pair,       parent: :key_pair){ seed "andrew" }
  factory(:bartek_key_pair,       parent: :key_pair){ seed "bartek" }
  factory(:usd_gateway_key_pair,  parent: :key_pair){ seed "usd_gateway" }
  factory(:eur_gateway_key_pair,  parent: :key_pair){ seed "eur_gateway" }
end