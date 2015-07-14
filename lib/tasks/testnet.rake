
namespace :testnet do
  desc "fund friendbot, rebuild_history"
  task :rebuild => ["testnet:fund_friendbot", "db:rebuild_history"]

  task :fund_friendbot => :environment do
    Rails.application.eager_load!

    source      = Stellar::KeyPair.from_raw_seed("allmylifemyhearthasbeensearching")
    destination = Stellar::KeyPair.from_seed ENV["FRIENDBOT_SECRET"]
    sequence    = StellarCore::Account.where(accountid: source.address).first.sequence

    tx = Stellar::Transaction.create_account({
      account:          source,
      destination:      destination,
      sequence:         sequence + 1,
      starting_balance: 10_000_000 * Stellar::ONE,
    })

    hex = tx.to_envelope(source).to_xdr(:hex)

    tx_sub = TransactionSubmission.new(hex)
    tx_sub.skip_finished_check!
    tx_sub.process

    unless tx_sub.received?
      puts "friendbot funding broke!"
      require 'pry'
      binding.pry
    end
  end
end
