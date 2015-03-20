require 'rails_helper'

RSpec.describe History::LedgerImporterJob, type: :job do
  let(:result){ subject.perform(sequence) }

  context "when importing the first ledger" do
    let(:sequence){ 1 }
    let(:hayashi_ledger){ Hayashi::LedgerHeader.where(ledgerseq: sequence).first }

    it "creates a new History::Ledger record" do
      expect{ result }.to change{ History::Ledger.count }.to(1)
    end

    it "correctly imports the hayashi ledger header" do
      expect(result.sequence).to eq(1)
      expect(result.previous_ledger_hash).to be_nil
      expect(result.ledger_hash).to eq(hayashi_ledger.ledgerhash)
    end
  end

  context "when importing the correct, next ledger" do
    before(:each){ subject.perform(1) } #import the first ledger
    let(:sequence){ 2 }
    let(:prev_hayashi_ledger){ Hayashi::LedgerHeader.where(ledgerseq: 1).first }
    let(:hayashi_ledger){ Hayashi::LedgerHeader.where(ledgerseq: sequence).first }

    it "creates a new History::Ledger record" do
      expect{ result }.to change{ History::Ledger.count }.by(1)
    end

    it "correctly imports the hayashi ledger header" do
      expect(result.sequence).to eq(2)
      expect(result.previous_ledger_hash).to eq(hayashi_ledger.prevhash)
      expect(result.previous_ledger_hash).to eq(prev_hayashi_ledger.ledgerhash)
      expect(result.ledger_hash).to eq(hayashi_ledger.ledgerhash)
    end
  end

  context "when importing a non-existent ledger" do
    let(:sequence){ 2**32 - 1 } #some large number that our test ledger is unlikely to contain
    it{ expect{ result }.to raise_error(ActiveRecord::RecordNotFound) }
    it{ expect{ result rescue nil }.to_not change{ History::Ledger.count } }
  end

  context "when importing a ledger that has the wrong prevhash" do
    before(:each){ subject.perform(1) }

    # stub the prevhash of the ledger to import with a bogus value
    before(:each) do
      header = Hayashi::LedgerHeader.at_sequence(2)
      header.prevhash = Digest::SHA256.hexdigest("not the right content")
      allow(Hayashi::LedgerHeader).to receive(:at_sequence){ header }
    end

    let(:sequence){ 2 }

    it{ expect{ result }.to raise_error(History::BrokenHistoryChainError) }
    it{ expect{ result rescue nil }.to_not change{ History::Ledger.count } }
  end

end

# This block of specifications below don't follow the normal flow of specs
# They are written more like normal tests (i.e. many assertions, larger size)
# to work around the fact that our transaction seeder system does not yet 
# produce deterministic results.
# 
# This is better than nothing, though
RSpec.describe History::LedgerImporterJob, "importing all fixture data", type: :job do
  let(:ledger_count){ Hayashi::LedgerHeader.count }

  before(:each) do
    ledger_indexes = ledger_count.times.map{|i| i + 1} 
    ledger_indexes.each{|idx| subject.perform(idx) }
  end

  it "properly imports all ledgers" do
    expect(History::Ledger.count).to eq(Hayashi::LedgerHeader.count)
  end

  it "properly imports all transactions" do
    expect(History::Transaction.count).to eq(Hayashi::Transaction.count)
  end

  it "properly imports all participants" do
    expect(History::TransactionParticipant.count).to eq(8)
  end

end

