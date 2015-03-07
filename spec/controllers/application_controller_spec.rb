require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    before_action :add_request_id

    def index
      return render(problem: {
        type: "out_of_space",
        requested_space: "100G",
        available_space: "100M",
      })
    end

    private
    def add_request_id
      # NOTE: controller specs don't go through ActionDispath, so `request.uuid`
      # doesn't work unless you set this env variable
      request.env["action_dispatch.request_id"] = "123"
    end
  end

  describe "Problem Rendering" do
    before(:each){ get :index }

    it "sets the 'type' field to a url into our error documentation"
    
    it "includes the request UUID in a URI as the 'instance' field" do
      expect(response).to match_json({
        instance: "request://123"
      })
    end

    it "includes extra fields defined on the problem hash in the response" do
      expect(response).to match_json({
        requested_space: "100G",
        available_space: "100M",
      })
    end
  end
end
