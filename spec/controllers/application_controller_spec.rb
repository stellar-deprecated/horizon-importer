require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    before_action :add_request_id

    def problem_via_exception
      raise "Explode!"
    end

    def problem_via_custom_exception
      raise AccessDeniedError
    end

    def problem_via_hash
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

  before(:each) do
    routes.draw { get ":action", controller: "anonymous" }
  end

  describe "Problem Rendering" do
    it "sets the 'type' field to a url into our error documentation"
    
    it "renders generic exceptions as an 'Internal Server Error' problem" do
      get :problem_via_exception
      expect(response).to match_json({
        title: "Internal Server Error"
      })
    end

    it "renders exceptions that override to_problem based on the override" do
      get :problem_via_custom_exception
      expect(response).to match_json({
        title: "Access Denied"
      })
    end

    it "defaults to 500 status code" do
      get :problem_via_exception
      expect(response).to have_status(:internal_server_error)
    end

    it "allows the provided problem to override the status code" do
      get :problem_via_custom_exception
      expect(response).to have_status(:forbidden)
    end
    
    it "includes the request UUID in a URI as the 'instance' field" do
      get :problem_via_hash
      expect(response).to match_json({
        instance: "request://123"
      })
    end

    it "includes extra fields defined on the problem hash in the response" do
      get :problem_via_hash
      expect(response).to match_json({
        requested_space: "100G",
        available_space: "100M",
      })
    end
  end
end
