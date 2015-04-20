require "rails_helper"

RSpec.describe ExceptionReporter do
  describe ".capture" do
    it "captures exception" do
      error = "error"
      allow(ExceptionReporter::CLIENT).to receive(:capture_exception)

      ExceptionReporter.capture(error)

      expect(ExceptionReporter::CLIENT).to have_received(:capture_exception).
        with(error)
    end
  end
end
