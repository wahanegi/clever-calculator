require 'rails_helper'

RSpec.describe "Api::V1::Customers", type: :request do
  let!(:user) { create :user }
  let!(:customer) { create :customer }
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
end
