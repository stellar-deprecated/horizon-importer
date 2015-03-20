
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
end