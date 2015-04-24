module Recorder
  class StellarCoreDumper
    def initialize
      @pg_dump = PgDump.new(Hayashi::Base, "#{SPEC_ROOT}/fixtures/stellar-core.sql")
    end

    # 
    # Dumps data from the stellar core database into the file at path `fixtures/hayashi.sql`,
    # overwriting it if it already exists.  When running the test suite with
    # RECORD=true, the TransactionSeeder will run prior to this, populating a
    # new ledger.  This method will then dump that populated core db state into
    # a sql file that subsequent test runs (i.e. with RECORD=false) will use
    # as fixture data
    # 
    def dump
      @pg_dump.dump
    end

    # 
    # Load data from `fixtures/hayashi.sql` into the stellar core database.  Normal test
    # runs will perform this prior to the suite being started, to establish
    # a baseline state for the hayashi core system
    # 
    def load
      @pg_dump.load
    end
  end
end