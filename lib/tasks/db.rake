
namespace :db do
  desc "clears all history tables and rebuilds the from the stellar_core db"
  task :rebuild_history => :environment do
    Rails.application.eager_load!

    # clear history
    History::Base.transaction do
      History::Base.descendants.each(&:delete_all)
    end

    # reimport
    # TODO: include activerecord-stream for better scalability
    StellarCore::LedgerHeader.order("ledgerseq ASC").all.each do |header|
      History::LedgerImporterJob.new.perform(header.sequence)
    end
  end

  SCENARIO_BASE_PATH = "spec/fixtures/scenarios"

  desc "runs testing scenarios, dumping results to tmp/secenarios"
  task :build_scenarios => :environment do
    Rails.application.eager_load!

    raise "This should only be run from RAILS_ENV='test'" unless Rails.env.test?

    scenarios = Dir["#{SCENARIO_BASE_PATH}/*.rb"]

    scenarios.each do |path|
      load_scenario path
    end
  end

  desc "loads a testing scenario"
  task :load_scenario => :environment do
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
    sql = `bundle exec scc -r #{path}`

    exit 1 unless $?.success?

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
