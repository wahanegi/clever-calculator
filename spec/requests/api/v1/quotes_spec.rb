require 'rails_helper'

RSpec.describe "Api::V1::Quotes", type: :request do
  let!(:user) { create :user }
  let!(:customer) { create :customer }
  let!(:contract_type) { create :contract_type }
  let(:valid_params) do
    { quote: { customer_id: customer.id,
               total_price: 0,
               step: 'customer_info',
               contract_type_id: contract_type.id,
               contract_start_date: Time.zone.today,
               contract_end_date: Time.zone.today + 30 } }
  end
  let(:invalid_params) do
    { quote: { customer_id: nil,
               total_price: -10,
               step: nil,
               contract_type_id: nil,
               contract_start_date: nil,
               contract_end_date: nil } }
  end
  let(:json_response) { response.parsed_body }

  before { sign_in user }

  describe "POST /api/v1/quotes" do
    context "with valid params" do
      before do
        post "/api/v1/quotes", params: valid_params
      end

      it "creates a new quote" do
        expect(response).to have_http_status(:created)
        expect(json_response["data"]["id"]).to eq(Quote.last.id.to_s)
        expect(json_response["data"]["attributes"]["step"]).to eq("customer_info")
      end

      it "associates the quote with the logged-in user" do
        expect(Quote.last.user).to eq(user)
      end
    end

    context "with invalid params" do
      before do
        post "/api/v1/quotes", params: invalid_params
      end

      it "does not create a quote" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns validation errors" do
        expect(json_response["errors"]).to be_present
      end
    end
  end

  describe "PUT /api/v1/quotes/:id" do
    let!(:quote) { create(:quote, customer: customer, user: user, contract_type: contract_type, total_price: 100, step: "customer_info") }
    let(:update_params) { { quote: { total_price: 150, step: "items_pricing" } } }
    let(:invalid_update_params) { { quote: { total_price: -10, step: nil } } }

    context "with valid params" do
      before { put "/api/v1/quotes/#{quote.id}", params: update_params }

      it "updates the quote" do
        expect(response).to have_http_status(:ok)
        expect(json_response["data"]["attributes"]["total_price"]).to eq("150.0")
        expect(json_response["data"]["attributes"]["step"]).to eq("items_pricing")
      end
    end

    context "with invalid params" do
      before { put "/api/v1/quotes/#{quote.id}", params: invalid_update_params }

      it "does not update the quote" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns validation errors" do
        expect(json_response["errors"]).to be_present
      end
    end
  end
end
