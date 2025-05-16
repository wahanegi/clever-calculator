require 'rails_helper'

RSpec.describe "API::V1::Categories", type: :request do
  let!(:user) { create(:user) }
  let(:json_response) { response.parsed_body }

  before { sign_in user }

  describe "GET /api/v1/categories" do
    context "when active and disabled categories exist" do
      let!(:active_category) { create(:category, name: "Active Category", is_disabled: false) }
      let!(:disabled_category) { create(:category, name: "Disabled Category", is_disabled: true) }
      let!(:item) { create(:item, category: active_category) }

      it "returns list of only active categories" do
        get "/api/v1/categories"

        expect(response).to have_http_status(:ok)
        expect(json_response["data"].size).to eq(1)
        expect(json_response["data"]).to be_an(Array)
        expect(json_response["data"][0]["attributes"]["name"]).to eq("Active Category")
      end
    end

    context "when no categories exist" do
      it "returns an empty array" do
        get "/api/v1/categories"

        expect(response).to have_http_status(:ok)
        expect(json_response["data"]).to be_an(Array)
        expect(json_response["data"]).to be_empty
      end
    end

    context "when only disabled categories exist" do
      let!(:disabled_category_one) { create(:category, is_disabled: true) }
      let!(:disabled_category_two) { create(:category, is_disabled: true) }

      it "returns an empty array" do
        get "/api/v1/categories"

        expect(response).to have_http_status(:ok)
        expect(json_response["data"]).to be_an(Array)
        expect(json_response["data"]).to be_empty
      end
    end
  end
end
