require 'rails_helper'

RSpec.describe WelcomeController do

  describe "GET index" do
    before(:each){ get :index, format: :json }

    it "succeeds" do
      expect(response).to have_http_status(:ok)
    end
  end

end
