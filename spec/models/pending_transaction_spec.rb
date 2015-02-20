require 'rails_helper'

RSpec.describe PendingTransaction, type: :model do
  with(:payment)
  with(:master_key_pair)
  let(:envelope){ payment.to_envelope(master_key_pair) }
  let(:envelope_hex){ envelope.to_xdr(:hex) }

  describe "validation" do
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:sending_address) }
    it { should validate_presence_of(:sending_sequence) }
    it { should validate_numericality_of(:sending_sequence) }
    it { should validate_presence_of(:tx_envelope) }
    it { should validate_presence_of(:tx_hash) }

    it "validates the `tx_envelope` is a valid xdr-encoded Stellar::TransactionEnvelope" do
      subject.validate_plausibility = true
      subject.tx_envelope = envelope_hex
      subject.valid?
      expect(subject.errors).to_not have_key(:tx_envelope)
      subject.tx_envelope = "foo" * 3
      subject.valid?
      expect(subject.errors).to have_key(:tx_envelope)
    end

    it "validates the `tx_hash` is a hex-encoded 32-byte hash" do
      subject.tx_hash = "FF" * 32
      subject.valid?
      expect(subject.errors).to_not have_key(:tx_hash)
      subject.tx_hash = "FF" * 31
      subject.valid?
      expect(subject.errors).to have_key(:tx_hash)
      subject.tx_hash = "I'm totally not hex encoded, but I am 64-bytes".rjust(64)
      subject.valid?
      expect(subject.errors).to have_key(:tx_hash)
    end

    it "validates the `sending_address` is a base58 encoded address" do

    end

    it "validates the `sending_sequence` is not in the past"
    it "validates the `signature` contained in the envelope is valid"
  end

  describe "#submit" do

    it "should not submit a transaction that is invalid"
    it "should transition `state` to 'submitted'"

  end


end
