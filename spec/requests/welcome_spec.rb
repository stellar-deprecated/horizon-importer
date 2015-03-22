require 'rails_helper'

RSpec.describe "Welcome Requests", type: :request do
  describe "GET /" do

    subject { response }
    before(:each){ get "/" }

    it{ should have_status(:ok) }
    it{ should match_json({
      :_links => {
        :accounts     => Hash,
        :transactions => Hash,
        :metrics      => Hash,
      },
    })}

  end
end
