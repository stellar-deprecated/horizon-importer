RSpec.configure do |c|
  c.before(:suite) do
    next unless RECORD
    # confirm empty ledger state
    # play transactions, confirming success
    Recorder::TransactionSeeder.new.run
    # dump database state
  end
end