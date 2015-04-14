require 'rails_helper'

RSpec.describe "Request Throttler", type: :request do

  it "throttles an ip address after 300 requests in a 5 minute period", :slow do    
    now = Time.now

    Timecop.freeze do
      300.times do |i|
        get "/"
        expect(response).to have_status(:ok)
      end

      get "/"
      expect(response).to have_status(:service_unavailable)

      get "/", nil, {'REMOTE_ADDR' => "10.0.0.1"} 
      expect(response).to have_status(:ok)
    end

    # skip 5 minutes ahead, ensure that we can request again
    
    Timecop.freeze(5.minutes.from_now(now)) do
      get "/"
      expect(response).to have_status(:ok)
    end
  end

  it "renders a problem response when throttling" do
    # trigger the throttle
    get '/', nil, {'X-Always-Throttle' => "true"} 
    get '/', nil, {'X-Always-Throttle' => "true"}

    get '/', nil, {'X-Always-Throttle' => "true"}
    expect(response).to have_status(:service_unavailable)
    expect(response).to match_json({
      type: "rate_limit_reached",
      title: "You have been rate limited.  Please try your request again later"
    })
  end

end