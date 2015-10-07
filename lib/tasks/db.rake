
namespace :db do
  desc "clears all history tables and rebuilds the from the stellar_core db"
  task :rebuild_history => ["db:clear_history", "db:batch_import_history"]

  desc "imports as many un-imported ledgers as possible"
  task :batch_import_history => :environment_without_importer do

    loop do
      last_ledger = History::Ledger.maximum(:sequence) || 0
      new_ledgers = StellarCore::LedgerHeader.
        where("ledgerseq > ?", last_ledger).
        order("ledgerseq ASC").
        limit(100).
        to_a

      break unless new_ledgers.any?

      new_ledgers.each{|h| History::LedgerImporterJob.new.perform(h.sequence)}
    end
  end

  desc "loads environment, but ensures that the ledger poller actor does not start up"
  task :environment_without_importer do
    ENV["IMPORT_HISTORY"] = "false"
    Rake::Task["environment"].invoke 
  end

  desc "updates imported ledger data that is out of date"
  task :batch_update_history => :environment_without_importer do
    scope = History::Ledger.
      where("importer_version < ?", History::LedgerImporterJob::VERSION).
      order("id ASC")

    updated = 0

    loop do
      to_update = scope.first(1000)
      break if to_update.empty?

      to_update.each do |hl|
        History::LedgerImporterJob.new.perform(hl.sequence)
        updated += 1
      end
    end

    puts "#{updated} records updated"
  end

  desc "clears all history tables"
  task :clear_history => :environment_without_importer do
    Rails.application.eager_load!
    History::Base.transaction do
      History::Base.descendants.each(&:delete_all)
    end
  end


  SCENARIO_BASE_PATH = "spec/fixtures/scenarios"

  desc "runs testing scenarios, dumping results to tmp/secenarios"
  task :build_scenarios => ["db:setup", :environment_without_importer] do
    Rails.application.eager_load!

    raise "This should only be run from RAILS_ENV='test'" unless Rails.env.test?

    scenarios = Dir["#{SCENARIO_BASE_PATH}/**/*.rb"]

    scenarios.each do |path|
      load_scenario path
    end
  end

  desc "loads a testing scenario"
  task :load_scenario => :environment_without_importer do
    Rails.application.eager_load!

    scenario_name = ENV["SCENARIO"]
    path          = "#{SCENARIO_BASE_PATH}/#{scenario_name}.rb"

    if path.blank?
      puts "please specify SCENARIO"
      exit 1
    end


    unless File.exist?(path)
      puts "#{path} not found"
      exit 1
    end

    load_scenario path
  end

  def load_scenario(path)
    sql = run_scenario path
    scenario_name = File.basename(path, ".rb")

    # dump the stellar-core data
    IO.write("#{SCENARIO_BASE_PATH}/#{scenario_name}-core.sql", sql)

    # load stellar-core data into test db
    cd = PgDump.new(StellarCore::Base, "#{SCENARIO_BASE_PATH}/#{scenario_name}-core.sql")
    cd.load

    reimport_history

    # dump horizon db
    hd = PgDump.new(History::Base, "#{SCENARIO_BASE_PATH}/#{scenario_name}-horizon.sql")
    hd.dump
  end

  def run_scenario(path)
    sql = `bundle exec scc -r #{path} --dump-root-db`

    unless $?.success?
      puts "failed while running #{path}:"
      puts sql
      exit 1
    end

    sql
  end

  def reimport_history
    # clear horizon
    History::Base.transaction{ History::Base.descendants.each(&:delete_all) }

    # reimport history
    StellarCore::LedgerHeader.order("ledgerseq ASC").all.each do |header|
      History::LedgerImporterJob.new.perform(header.sequence)
    end
  end
end
