require 'rails_helper'

RSpec.describe "Api::V1::Customers", type: :request do
  let!(:user) { create :user }
  let!(:customer) { create :customer, company_name: "Company ABC", position: "CTO", email: "cto@example.com" }
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:json_response) { response.parsed_body }

  before { sign_in user }

  describe "GET /api/v1/customers" do
    before do
      get "/api/v1/customers"
    end

    it "returns a list of customers" do
      expect(response).to have_http_status(:ok)
      expect(json_response["data"].size).to eq(1)

      returned_customer = json_response["data"].first["attributes"]
      expected_customer = CustomerSerializer.new(customer).serializable_hash[:data][:attributes]

      CustomerSerializer.attributes_to_serialize.each_key do |attribute|
        expect(returned_customer).to have_key(attribute)
        expect(returned_customer[attribute]).to eq(expected_customer[attribute])
      end
    end
  end

  describe "POST /api/v1/customers/upsert" do
    context "when updating an existing customer" do
      let(:update_params) do
        { customer: { company_name: "Company ABC", email: "ceo@example.com", position: "CEO" } }
      end

      before { post "/api/v1/customers/upsert", params: update_params.to_json, headers: headers }

      it "updates the customer" do
        expect(response).to have_http_status(:ok)
        expect(json_response["data"]["id"]).to eq(customer.id.to_s)
        expect(customer.reload.attributes).to include("email" => "ceo@example.com", "position" => "CEO")
      end
    end

    context "when creating a new customer" do
      let(:create_params) do
        { customer: { company_name: "NewCo", email: "jane@example.com", position: "Founder" } }
      end

      it "creates a new customer record" do
        expect { post "/api/v1/customers/upsert", params: create_params.to_json, headers: headers }
          .to change(Customer, :count).by(1)
        new_customer = Customer.find_by(company_name: "NewCo")
        expect(new_customer.email).to eq("jane@example.com")
        expect(json_response["data"]["attributes"]["company_name"]).to eq("NewCo")
      end
    end

    context "with case-insensitive duplicate company name" do
      let(:duplicate_params) do
        { customer: { company_name: "company abc", email: "new@example.com" } }
      end

      it "updates the existing customer instead of creating" do
        expect { post "/api/v1/customers/upsert", params: duplicate_params.to_json, headers: headers }
          .not_to change(Customer, :count)
        expect(response).to have_http_status(:ok)
        expect(customer.reload.email).to eq("new@example.com")
      end
    end

    context "with empty or whitespace company_name" do
      let(:empty_params) { { customer: { company_name: "", email: "test@example.com" } } }
      let(:whitespace_params) { { customer: { company_name: "   ", email: "test@example.com" } } }

      it "rejects empty company_name" do
        post "/api/v1/customers/upsert", params: empty_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Company name can't be blank")
      end

      it "rejects whitespace-only company_name" do
        post "/api/v1/customers/upsert", params: whitespace_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Company name can't be blank")
      end
    end

    context "with no changes to existing customer" do
      let(:no_change_params) do
        { customer: { company_name: "Company ABC", email: "cto@example.com", position: "CTO" } }
      end

      it "returns success without errors" do
        post "/api/v1/customers/upsert", params: no_change_params.to_json, headers: headers
        expect(response).to have_http_status(:ok)
        expect(customer.reload.attributes).to include("email" => "cto@example.com", "position" => "CTO")
      end
    end

    context "when unauthenticated" do
      before do
        sign_out user
        post "/api/v1/customers/upsert", params: { customer: { company_name: "TestCo" } }.to_json, headers: headers
      end

      it "returns unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
