require "rails_helper"

RSpec.describe TransactionSubmission do
  describe ".capture" do
    it "reports exception to Sentry" do
      error = "error"
      allow(Raven).to receive(:capture_exception)

      ExceptionReporter.capture(error)

      expect(ExceptionReporter::CLIENT).to have_received(:capture_exception).
        with(error)
    end
  end
end
