require 'rails_helper'

RSpec.describe History::LedgerImporterJob, type: :job do
  let(:result){ subject.perform(sequence) }

  context "when importing the first ledger" do
    let(:sequence){ 1 }
    let(:stellar_core_ledger){ StellarCore::LedgerHeader.where(ledgerseq: sequence).first }

    it "creates a new History::Ledger record" do
      expect{ result }.to change{ History::Ledger.count }.to(1)
    end

    it "correctly imports the stellar_core ledger header" do
      expect(result.sequence).to eq(1)
      expect(result.previous_ledger_hash).to be_nil
      expect(result.ledger_hash).to eq(stellar_core_ledger.ledgerhash)
    end
  end

  context "when importing the correct, next ledger" do
    before(:each){ subject.perform(1) } #import the first ledger
    let(:sequence){ 2 }
    let(:prev_stellar_core_ledger){ StellarCore::LedgerHeader.where(ledgerseq: 1).first }
    let(:stellar_core_ledger){ StellarCore::LedgerHeader.where(ledgerseq: sequence).first }

    it "creates a new History::Ledger record" do
      expect{ result }.to change{ History::Ledger.count }.by(1)
    end

    it "correctly imports the stellar_core ledger header" do
      expect(result.sequence).to eq(2)
      expect(result.previous_ledger_hash).to eq(stellar_core_ledger.prevhash)
      expect(result.previous_ledger_hash).to eq(prev_stellar_core_ledger.ledgerhash)
      expect(result.ledger_hash).to eq(stellar_core_ledger.ledgerhash)
    end
  end

  context "when importing a non-existent ledger" do
    let(:sequence){ 2**31 - 1 } #some large number that our test ledger is unlikely to contain
    it{ expect{ result }.to raise_error(ActiveRecord::RecordNotFound) }
    it{ expect{ result rescue nil }.to_not change{ History::Ledger.count } }
  end

  context "when importing a ledger that has the wrong prevhash" do
    before(:each){ subject.perform(1) }

    # stub the prevhash of the ledger to import with a bogus value
    before(:each) do
      header = StellarCore::LedgerHeader.at_sequence(2)
      header.prevhash = Digest::SHA256.hexdigest("not the right content")
      allow(StellarCore::LedgerHeader).to receive(:at_sequence){ header }
    end

    let(:sequence){ 2 }

    it{ expect{ result }.to raise_error(History::BrokenHistoryChainError) }
    it{ expect{ result rescue nil }.to_not change{ History::Ledger.count } }
  end

end


RSpec.describe History::LedgerImporterJob, "importing account_merge operations", type: :job do
  load_scenario "account_merge"
  reimport_history

  let(:op){ History::Operation.find(17179873280)}

  it "sets `account`" do
    expect(op.details["account"]).to eq("gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ")
  end

  it "sets `into`" do
    expect(op.details["into"]).to eq("gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA")
  end
end


RSpec.describe History::LedgerImporterJob, "importing path_payment operations", type: :job do
  load_scenario "pathed_payment"
  reimport_history
  let(:op){ History::Operation.find(30064775168)}

  it "sets `from`" do
    expect(op.details["from"]).to eq("gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ")
  end

  it "sets `to`" do
    expect(op.details["to"]).to eq("gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA")
  end

  it "sets `amount`" do
    expect(op.details["amount"]).to eq("10")
  end
end

RSpec.describe History::LedgerImporterJob, "importing change_trust operations", type: :job do
  load_scenario "allow_trust"
  reimport_history
  let(:op){ History::Operation.find(21474840576)}

  it "sets `trustee`" do
    expect(op.details["trustee"]).to eq("gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq")
  end

  it "sets `trustor`" do
    expect(op.details["trustor"]).to eq("gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ")
  end

  it "sets `limit`" do
    expect(op.details["limit"]).to eq("4000")
  end
end

RSpec.describe History::LedgerImporterJob, "importing allow_trust operations", type: :job do
  load_scenario "allow_trust"
  reimport_history
  let(:allow_op){ History::Operation.find(25769807872)}
  let(:revoke_op){ History::Operation.find(30064775168)}

  it "sets `trustee`" do
    expect(allow_op.details["trustee"]).to eq("gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq")
    expect(revoke_op.details["trustee"]).to eq("gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq")
  end

  it "sets `trustor`" do
    expect(allow_op.details["trustor"]).to eq("gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ")
    expect(revoke_op.details["trustor"]).to eq("gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ")
  end

  it "sets `authorize`" do
    expect(allow_op.details["authorize"]).to eq("true")
    expect(revoke_op.details["authorize"]).to eq("false")
  end
end

RSpec.describe History::LedgerImporterJob, "importing set_options operations", type: :job do
  load_scenario "set_options"
  reimport_history

  describe "inflation_dest details" do
    let(:op){ History::Operation.find(17179873280)}

    it "sets `inflation_dest`" do
      expect(op.details["inflation_dest"]).to eq("gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA")
    end
  end

  describe "signer details" do
    let(:add_op){ History::Operation.find(17179877376)}
    let(:remove_op){ History::Operation.find(21474840576)}

    it "sets `signer_key`" do
      expect(add_op.details["signer_key"]).to eq("gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq")
      expect(remove_op.details["signer_key"]).to eq("gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq")
    end

    it "sets `signer_weight`" do
      expect(add_op.details["signer_weight"]).to eq("1")
      expect(remove_op.details["signer_weight"]).to eq("0")
    end
  end

  describe "thresholds details" do
    let(:op){ History::Operation.find(17179881472)}

    it "sets `low_threshold`" do
      expect(op.details["low_threshold"]).to eq("0")
    end

    it "sets `medium_threshold`" do
      expect(op.details["medium_threshold"]).to eq("2")
    end

    it "sets `high_threshold`" do
      expect(op.details["high_threshold"]).to eq("2")
    end

    it "sets `master_key_weight`" do
      expect(op.details["master_key_weight"]).to eq("2")
    end
  end

  describe "set flag details" do
    it "sets `flags_set`"
  end

  describe "clear flag details" do
    it "sets `flags_cleared`"
  end

  describe "home domain details" do
    it "sets `home_domain`"
  end
end



# This block of specifications below don't follow the normal flow of specs
# They are written more like normal tests (i.e. many assertions, larger size)
# to work around the fact that our transaction seeder system does not yet
# produce deterministic results.
#
# This is better than nothing, though
RSpec.describe History::LedgerImporterJob, "importing all fixture data", type: :job do
  let(:ledger_count){ StellarCore::LedgerHeader.count }

  before(:each) do
    ledger_indexes = ledger_count.times.map{|i| i + 1}
    ledger_indexes.each{|idx| subject.perform(idx) }
  end

  it "properly imports all ledgers" do
    expect(History::Ledger.count).to eq(StellarCore::LedgerHeader.count)
  end

  it "properly imports all transactions" do
    expect(History::Transaction.count).to eq(StellarCore::Transaction.count)
  end

  it "properly imports all participants" do
    expect(History::TransactionParticipant.count).to eq(8)
  end

end
