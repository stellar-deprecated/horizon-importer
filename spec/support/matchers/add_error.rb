RSpec::Matchers.define :add_error do |expected|
  match do |actual|
    actual.call
    subject.valid?
    subject.errors.has_key?(expected)
  end
  
  def supports_block_expectations?
    true
  end
end