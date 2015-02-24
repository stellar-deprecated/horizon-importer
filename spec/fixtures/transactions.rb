account :master, Stellar::KeyPair.from_raw_seed("masterpassphrasemasterpassphrase")
account :scott,  Stellar::KeyPair.from_seed("s3QvCFTAqdizR5smxCqHXehZzSMyfqFHwKKXACGjkCz2dZGTmMp")
account :bartek, Stellar::KeyPair.from_seed("sfxFjhCU4rbNtC7ujbwFmZiz8CfarCkCT4zizk6MeYf9DU5X5pH")
account :andrew, Stellar::KeyPair.from_seed("sfv8H5a8rbLZNVr6pY8a6quMYXiientGotxxe3cGjvX2VnkYaHG")

payment :master, :scott,  [:native, 1000_000000]
payment :master, :bartek, [:native, 1000_000000]
payment :master, :andrew, [:native, 1000_000000]

payment :scott, :andrew,  [:native, 50_000000]