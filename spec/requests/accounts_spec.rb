require 'rails_helper'

RSpec.describe "Account Requests", type: :request do
  describe "GET /accounts/:id" do
    subject { response }
    let(:id){ addresses.join(",") }
    before(:each){ get "/accounts/#{id}" }

    context "with a single unknown account" do
      let(:addresses){["not_real"]}
      
      it{ should have_status(:not_found) }
      it{ should match_json({
        type:   "not_found",
        status: 404,
        title:  "Resource Missing",
      })}
    end

    context "with a single known account" do
      let(:addresses){[create(:master_key_pair).address]}
      let(:address){ addresses.first }
      it{ should have_status(:ok) }
      
      it{ should match_json({
        id: address,
        :_links => {
          :self => {
            :href => "http://www.example.com/accounts/#{address}"
          }
        }
      }.strict!)}
    end

    context "with multiple known accounts" do
      let(:addresses){[
        create(:master_key_pair), 
        create(:scott_key_pair),
      ].map(&:address)}
      
      it{ should have_status(:ok) }
      it{ should match_json({
        _embedded: {
          addresses[0] => {
            id: addresses[0],
          },
          addresses[1] => {
            id: addresses[1],
          },
        }
      })}

    end

    context "with a mix of known and unknown accounts" do
      let(:addresses){[
        create(:master_key_pair).address,
        "not_real",
      ]}

      it{ should have_status(:ok) }
      it{ should match_json({
        _embedded: {
          addresses[0] => {
            id: addresses[0],
          },
          addresses[1] => nil,
        }
      })}
    end

    context "with multiple unknown accounts" do
      let(:addresses){[
        "not_real",
        "also_not_real",
      ]}

      it{ should have_status(:not_found) }
      it{ should match_json({
        type:   "not_found",
        status: 404,
        title:  "Resource Missing",
      })}
    end
  end
end
