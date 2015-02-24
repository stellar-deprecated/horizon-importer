RSpec.configure do |c|
  c.before(:suite) do
    next unless RECORD

    raise "Hayashi Accounts table not at default state" if Hayashi::Account.count > 1
    raise "Hayashi TxHistory table not at default state" if Hayashi::Transaction.any?
    
    # play transactions, TODO:confirm success
    Recorder::TransactionSeeder.new.run
    Recorder::HayashiDumper.new.dump
  end
end

RSpec.configure do |c|
  c.before(:suite) do
    next if RECORD # if we're recording, don't load the database
    Recorder::HayashiDumper.new.load
  end
end