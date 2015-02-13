require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do

  describe "GET index" do
    before(:each){ get :index, format: :json }

    it "renders the index template" do
      expect(response).to render_template("index")
    end

    it "succeeds" do
      expect(response).to have_http_status(:ok)
    end
  end

end
