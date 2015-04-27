
namespace :db do
  desc "clears all history tables and rebuilds the from the hayashi db"
  task :rebuild_history => :environment do
    Rails.application.eager_load!

    # clear history
    History::Base.transaction do
      History::Base.descendants.each(&:delete_all)
    end

    # reimport
    # TODO: include activerecord-stream for better scalability
    Hayashi::LedgerHeader.order("ledgerseq ASC").all.each do |header|
      History::LedgerImporterJob.new.perform(header.sequence)
    end
  end


  desc "runs testing scenarios, dumping results to tmp/secenarios"
  task :build_scenarios => :environment do
    Rails.application.eager_load!

    raise "This should only be run from RAILS_ENV='test'" unless Rails.env.test?

    scenarios = Dir["spec/fixtures/scenarios/*.rb"]
    FileUtils.mkdir_p "tmp/scenarios"
    require 'stellar_core_commander'
    
    stellar_core_path = `which stellar-core`.strip
    raise "stellar-core is not on PATH" unless $?.success?

    cmd = StellarCoreCommander::Commander.new stellar_core_path
    cmd.cleanup_at_exit!    

    scenarios.each do |path|
      scenario_name = File.basename(path, ".rb")
      process    = cmd.make_process
      transactor = StellarCoreCommander::Transactor.new(process)

      process.run
      process.wait_for_ready

      transactor.run_recipe path
      transactor.close_ledger

      # dump the stellar-core data
      IO.write("tmp/scenarios/#{scenario_name}-core.sql", process.dump_database)

      # clear horizon
      History::Base.transaction{ History::Base.descendants.each(&:delete_all) }

      # reimport history
      Hayashi::Base.clear_all_connections!
      database_url = "postgres://localhost/#{process.database_name}"
      Hayashi::Base.establish_connection database_url

      Hayashi::LedgerHeader.order("ledgerseq ASC").all.each do |header|
        History::LedgerImporterJob.new.perform(header.sequence)
      end

      # dump horizon db
      d = PgDump.new(History::Base, "tmp/scenarios/#{scenario_name}-horizon.sql")
      d.dump

      Hayashi::Base.clear_all_connections!
    end

  end
end