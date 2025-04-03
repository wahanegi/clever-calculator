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
      CustomerSerializer.attributes_to_serialize.each_key do |attribute|
        expect(json_response["data"][0]["attributes"]).to have_key(attribute)
        expect(json_response["data"][0]["attributes"][attribute]).to eq(customer.send(attribute))
      end
    end
  end
end
