RSpec.configure do |c| 
  c.before(:example, type: :request) do
    reset! unless integration_session # populate integration_session, so we can extend it
    integration_session.accept = "application/json"
  end
end