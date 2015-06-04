
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


  desc "runs testing scenarios, dumping results to tmp/secenarios"
  task :build_scenarios => :environment do
    Rails.application.eager_load!

    raise "This should only be run from RAILS_ENV='test'" unless Rails.env.test?

    base_path = "spec/fixtures/scenarios"
    scenarios = Dir["#{base_path}/*.rb"]

    scenarios.each do |path|
      sql = run_scenario path
      scenario_name = File.basename(path, ".rb")

      # dump the stellar-core data
      IO.write("#{base_path}/#{scenario_name}-core.sql", sql)

      # load stellar-core data into test db
      cd = PgDump.new(StellarCore::Base, "#{base_path}/#{scenario_name}-core.sql")
      cd.load

      reimport_history

      # dump horizon db
      hd = PgDump.new(History::Base, "#{base_path}/#{scenario_name}-horizon.sql")
      hd.dump

      StellarCore::Base.clear_all_connections!
    end
  end

  desc "loads a testing scenario"
  task :load_scenario => :environment do
    Rails.application.eager_load!

    scenario_name = ENV["SCENARIO"]
    base_path     = "spec/fixtures/scenarios"
    path          = "#{base_path}/#{scenario_name}.rb"

    if path.blank?
      puts "please specify SCENARIO"
      exit 1
    end


    unless File.exist?(path)
      puts "#{path} not found"
      exit 1
    end

    `psql #{ENV["DATABASE_URL"]} < #{base_path}/#{scenario_name}-horizon.sql`
    `psql #{ENV["STELLAR_CORE_DATABASE_URL"]} < #{base_path}/#{scenario_name}-core.sql`
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
