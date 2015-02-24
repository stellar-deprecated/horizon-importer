require 'yaml_db'

module Recorder
  class HayashiDumper
    def initialize()
      @helper = SerializationHelper::Base.new(YamlDb::Helper)
    end

    # 
    # Dumps data from the hayashi core database into the file at path `data_path`,
    # overwriting it if it already exists.  When running the test suite with
    # RECORD=true, the TransacitonSeeder will run prior to this, populating a
    # new ledger.  This method will then dump that populated core db state into
    # a yaml file that subsequent test runs (i.e. with RECORD=false) will use
    # as fixture data
    # 
    def dump
      on_hayashi{ @helper.dump(data_path) }
    end


    # 
    # Load data from `data_path` into the hayashi core database.  Normal test
    # runs will perform this prior to the suite being started, to establish
    # a baseline state for the hayashi core system
    # 
    def load
      return unless File.exist?(data_path)
      on_hayashi{ @helper.load(data_path) }
    end

    private

    # 
    # The path where hayashi core db data is dumped/loaded
    # 
    # @return [String] the path
    def data_path
      "#{SPEC_ROOT}/fixtures/hayashi.yml"
    end

    # 
    # Sets the base activerecord database connection to the hayashi core
    # database.  YamlDb does not provide a facility to work with any connection
    # other than `ActiveRecord::Base.connection`, so we're forced for the time
    # being to use this method.
    # 
    def on_hayashi
      ActiveRecord::Base.establish_connection :hayashi  
      yield
    ensure
      ActiveRecord::Base.establish_connection 
    end
  end
end