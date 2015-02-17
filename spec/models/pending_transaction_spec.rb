require 'rails_helper'

RSpec.describe PendingTransaction, type: :model do

  describe "validation" do
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:sending_address) }
    it { should validate_presence_of(:sending_sequence) }
    it { should validate_numericality_of(:sending_sequence) }
    it { should validate_presence_of(:tx_envelope) }
    it { should validate_presence_of(:tx_hash) }

    it "validates the tx_envelope is a valid xdr-encoded Stellar::TransactionEnvelope"
    it "validates the tx_hash is a hex-encoded 32-byte hash"
    it "validates the sending_address is a hex-encoded 32-byte hash"
    it "validates the sending_sequence is not in the past"
    it "validates the signature contained in the envelope is valid"
  end


end
