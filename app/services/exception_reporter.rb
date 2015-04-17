class ExceptionReporter
  CLIENT = Raven

  def self.capture(exception)
    CLIENT.capture_exception(exception)
  end
end
