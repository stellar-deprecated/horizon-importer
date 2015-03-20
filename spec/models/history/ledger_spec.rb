require 'rails_helper'

RSpec.describe History::Ledger, type: :model do
  subject{ build(:history_ledger) }
  
  it { should validate_presence_of(:sequence) }
  it { should validate_presence_of(:ledger_hash) }
  it { should validate_presence_of(:closed_at) }
  it { should validate_presence_of(:transaction_count) }
  it { should validate_presence_of(:operation_count) }

  it { should validate_numericality_of(:sequence) }
  it { should validate_numericality_of(:transaction_count) }
  it { should validate_numericality_of(:operation_count) }

  it { should validate_uniqueness_of(:sequence)}
  it { should validate_uniqueness_of(:ledger_hash)}
  it { should validate_uniqueness_of(:previous_ledger_hash)}

  it "validates the `ledger_hash` is a hex-encoded 32-byte hash" do
    expect{ subject.ledger_hash = "ff" * 32 }.to_not add_error(:ledger_hash)
    expect{ subject.ledger_hash = "ff" * 31 }.to add_error(:ledger_hash)
    expect{ subject.ledger_hash = "I'm totally not hex encoded, but I am 64-bytes".rjust(64) }.to add_error(:ledger_hash)
  end

  it "validates the `previous_ledger_hash` is a hex-encoded 32-byte hash" do
    expect{ subject.previous_ledger_hash = nil }.to_not add_error(:previous_ledger_hash)
    expect{ subject.previous_ledger_hash = "ff" * 32 }.to_not add_error(:previous_ledger_hash)
    expect{ subject.previous_ledger_hash = "ff" * 31 }.to add_error(:previous_ledger_hash)
    expect{ subject.previous_ledger_hash = "I'm totally not hex encoded, but I am 64-bytes".rjust(64) }.to add_error(:previous_ledger_hash)
  end

end
