module ScenarioHelpers
  def load_scenario(scenario_name, load_horizon=false)
    before(:each) do
      pg_dump = PgDump.new(StellarCore::Base, "#{SPEC_ROOT}/fixtures/scenarios/#{scenario_name}-core.sql")
      pg_dump.load

      if load_horizon
        pg_dump = PgDump.new(History::Base, "#{SPEC_ROOT}/fixtures/scenarios/#{scenario_name}-horizon.sql")
        pg_dump.load
      end
    end
  end

  def reimport_history
    before(:each) do
      ledger_count = StellarCore::LedgerHeader.count
      ledger_indexes = ledger_count.times.map{|i| i + 1}
      job = History::LedgerImporterJob.new
      ledger_indexes.each{|idx| job.perform(idx) }
    end
  end
end

RSpec.configure{|c| c.extend ScenarioHelpers}
