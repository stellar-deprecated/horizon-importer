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
      expect{ subject.tx_envelope = envelope_hex }.to_not add_error(:tx_envelope)
      expect{ subject.tx_envelope = "foo" * 3 }.to add_error(:tx_envelope)
    end

    it "validates the `tx_hash` is a hex-encoded 32-byte hash" do
      expect{ subject.tx_hash = "ff" * 32 }.to_not add_error(:tx_hash)
      expect{ subject.tx_hash = "ff" * 31 }.to add_error(:tx_hash)
      expect{ subject.tx_hash = "I'm totally not hex encoded, but I am 64-bytes".rjust(64) }.to add_error(:tx_hash)
    end

    it "validates the `sending_address` is a base58 encoded address" do
      expect{ subject.sending_address = "gsYRSEQhTffqA9opPepAENCr2WG6z5iBHHubxxbRzWaHf8FBWcu"  }.to_not add_error(:sending_address)
      expect{ subject.sending_address = nil  }.to add_error(:sending_address)
      expect{ subject.sending_address = "f0o"  }.to add_error(:sending_address)
      expect{ subject.sending_address = "s9aaUNPaT9t1x7vCeDzQYvLZDm5XxSUKkwnqQowV6D3kMr678uZ"  }.to add_error(:sending_address)
    end

    it "validates the `sending_sequence` is not in the past" do
      subject.validate_plausibility = true

      # test presence of error
      payment.seq_num = 1
      envelope_hex = payment.to_envelope(master_key_pair).to_xdr(:hex)
      expect{ subject.tx_envelope = envelope_hex }.to add_error(:sending_sequence)

      # test abscence of error
      payment.seq_num = 4
      envelope_hex = payment.to_envelope(master_key_pair).to_xdr(:hex)
      expect{ subject.tx_envelope = envelope_hex}.to_not add_error(:sending_sequence)
    end

    it "validates the `signature` contained in the envelope is valid" do
      subject.validate_plausibility = true

      other        = create(:key_pair)
      envelope     = payment.to_envelope(other)

      # signed by wrong account
      expect{ subject.tx_envelope = envelope.to_xdr(:hex) }.to add_error(:tx_envelope)

      # not signed
      envelope.signatures = []
      expect{ subject.tx_envelope = envelope.to_xdr(:hex) }.to add_error(:tx_envelope)

      # correctly signed
      expect{ subject.tx_envelope = envelope_hex }.to_not add_error(:tx_envelope)
    end
  end

  describe "#submit" do

    it "should not submit a transaction that is invalid"
    it "should transition `state` to 'submitted'"

  end


end
