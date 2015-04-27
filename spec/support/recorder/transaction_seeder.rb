module Recorder
  class TransactionSeeder
    
    def initialize()
      @recipe_path = "#{SPEC_ROOT}/fixtures/scenarios/base.rb"
      @output_path = "#{SPEC_ROOT}/fixtures/stellar-core.sql"
      @stellar_core_path = `which stellar-core`.strip

      raise "stellar-core is not on PATH" unless $?.success?
    end

    def run
      require 'stellar_core_commander'
      VCR.turned_off do
        begin
          WebMock.allow_net_connect!
          cmd        = StellarCoreCommander::Commander.new @stellar_core_path
          process    = cmd.make_process
          transactor = StellarCoreCommander::Transactor.new(process)

          # run recipe
          process.run
          process.wait_for_ready
          transactor.run_recipe @recipe_path
          transactor.close_ledger
          process.shutdown

          # dump results
          IO.write(@output_path, process.dump_database)

          # cleanup tmpdir/db/etc.
          process.cleanup

        ensure
          WebMock.disable_net_connect!
        end

      end
    end
  end
end