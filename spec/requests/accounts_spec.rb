require 'rails_helper'

RSpec.describe "Account Requests", type: :request do
  describe "GET /accounts/:id" do
    subject { response }
    let(:id){ addresses.join(",") }
    before(:each){ get "/accounts/#{id}" }

    context "with a single unknown account" do
      let(:addresses){["not_real"]}
      
      it{ should have_status(:missing) }
      it "should have an appropriate missing error body"
    end

    context "with a single known account" do
      let(:addresses){[create(:master_key_pair).address]}
      it{ should have_status(:ok) }
      it "should return the account's details"
    end

    context "with multiple known accounts", :pending do
      let(:addresses){[
        create(:master_key_pair), 
        create(:scott_key_pair),
      ].map(&:address)}
      
      it{ should have_status(:ok) }
      it "should return each account's details, mapped by account id"
    end

    context "with a mix of known and unknown accounts", :pending do
      let(:addresses){[
        create(:master_key_pair).address,
        "not_real",
      ]}

      it{ should have_status(:ok) }
      it "should return each found account's details, mapped by account id"
      it "should return nil for each unknown account"
    end

    context "with multiple unknown accounts", :pending do
      let(:addresses){[
        "not_real",
        "also not real",
      ]}

      it{ should have_status(:missing) }
      it "should have an appropriate missing error body"
    end
  end
end
