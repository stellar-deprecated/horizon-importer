module Recorder
  class HayashiDumper
    def initialize
    end

    # 
    # Dumps data from the hayashi core database into the file at path `data_path`,
    # overwriting it if it already exists.  When running the test suite with
    # RECORD=true, the TransactionSeeder will run prior to this, populating a
    # new ledger.  This method will then dump that populated core db state into
    # a sql file that subsequent test runs (i.e. with RECORD=false) will use
    # as fixture data
    # 
    def dump
      hayashi_db = Hayashi::Base.connection_config[:database]
      system("pg_dump #{hayashi_db} --clean --no-owner", out: data_path)
    end

    # 
    # Load data from `data_path` into the hayashi core database.  Normal test
    # runs will perform this prior to the suite being started, to establish
    # a baseline state for the hayashi core system
    # 
    def load
      hayashi_db = Hayashi::Base.connection_config[:database]
      system("psql #{hayashi_db}", in: data_path, out: "/dev/null", err: "/dev/null")
    end

    private


    # 
    # The path where hayashi core db data is dumped/loaded
    # 
    # @return [String] the path
    def data_path
      "#{SPEC_ROOT}/fixtures/hayashi.sql"
    end

  end
end