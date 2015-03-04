require 'rails_helper'

RSpec.describe "Account Requests", type: :request do
  describe "GET /accounts/:id" do
    subject { response }
    before(:each){ get "/accounts/#{id}" }

    context "with a single unknown account" do
      let(:id){ "not_real" }
      it{ should have_status(:missing) }
      it "should have an appropriate missing error body"
    end

    context "with a single known account" do
      let(:id){ "gM4gu1GLe3vm8LKFfRJcmTt1eaEuQEbo61a8BVkGcou78m21K7" }
      it{ should have_status(:ok) }
      it "should return the account's details"
    end

    context "with multiple known accounts" do
      let(:id){ "gM4gu1GLe3vm8LKFfRJcmTt1eaEuQEbo61a8BVkGcou78m21K7,gT9jHoPKoErFwXavCrDYLkSVcVd9oyVv94ydrq6FnPMXpKHPTA" }
      it{ should have_status(:ok) }
      it "should return each account's details, mapped by account id"
    end

    context "with a mix of known and unknown accounts" do
      let(:id){ "gM4gu1GLe3vm8LKFfRJcmTt1eaEuQEbo61a8BVkGcou78m21K7,not_real" }
      it{ should have_status(:ok) }
      it "should return each found account's details, mapped by account id"
      it "should return nil for each unknown account"
    end

    context "with multiple unknown accounts" do
      let(:id){ "not_real, also_not_real" }
      it{ should have_status(:missing) }
      it "should have an appropriate missing error body"
    end
  end
end
