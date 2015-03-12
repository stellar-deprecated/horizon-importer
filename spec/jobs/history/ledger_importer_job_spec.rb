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