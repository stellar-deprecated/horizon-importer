RSpec::Matchers.define :have_status do |expected|
  match do |actual|
    code = Rack::Utils.status_code(expected)
    expect(actual.status).to eq(code)
  end
  
  failure_message do |actual|
    "expected #{expected}, but got #{actual.status}"
  end

  failure_message_when_negated do |actual|
    "didn't expect #{expected}, but got it"
  end
end