RSpec.configure do |c|
  c.before(:suite) do
    if RECORD
      Recorder::TransactionSeeder.new.run
    end

    pg_dump = PgDump.new(StellarCore::Base, "#{SPEC_ROOT}/fixtures/stellar-core.sql")
    pg_dump.load
  end
end