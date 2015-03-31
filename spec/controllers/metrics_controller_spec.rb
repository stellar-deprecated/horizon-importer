require 'rails_helper'

RSpec.describe MetricsController, type: :controller do

  describe "GET index" do
    before(:each){ get :index, format: :json }

    it "renders the index template" do
      expect(response).to match_json({
        "_links" => {"self" => Hash},

        "requests.total"        => Hash,
        "requests.succeeded"    => Hash,
        "requests.failed"       => Hash,
        "celluloid.actor_count" => Fixnum,
      })
    end

    it "succeeds" do
      expect(response).to have_http_status(:ok)
    end
  end
end
