require "rails_helper"

RSpec.describe TransactionSubmission, type: :model do
  describe "#process" do
    context "when connection fails" do
      it "reports exception" do
        stub_parsed_transaction_envelope
        transaction_envelope = SecureRandom.hex
        exception = Faraday::ConnectionFailed.new("error")
        allow($stellard).to receive(:get).and_raise(exception)
        allow(ExceptionReporter).to receive(:capture)
        transaction_submission = TransactionSubmission.new(transaction_envelope)

        transaction_submission.process

        expect(ExceptionReporter).to have_received(:capture).with(exception)
      end
    end
  end

  def stub_parsed_transaction_envelope
    parsed_envelope = double("parsed_envelope", tx: double(hash: "hash"))
    allow(Stellar::TransactionEnvelope).to receive(:from_xdr).
      and_return(parsed_envelope)
  end
end
