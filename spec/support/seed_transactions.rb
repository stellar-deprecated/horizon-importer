RSpec.configure do |c|
  c.before(:suite) do
    pg_dump = PgDump.new(StellarCore::Base, "#{SPEC_ROOT}/fixtures/scenarios/base-core.sql")
    pg_dump.load
  end
end
