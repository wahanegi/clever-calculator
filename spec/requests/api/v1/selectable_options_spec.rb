require 'rails_helper'

RSpec.describe "Api::V1::SelectableOptions", type: :request do
  let!(:user) { create :user }
  let!(:customer) { create :customer }
  let!(:item_without_category) { create :item, category: nil }
  let!(:category) { create(:category) }
  let!(:items) { create_list :item, 2, category: category }

  let(:json_response) { response.parsed_body }

  before { sign_in user }

  describe "GET /api/v1/quote_items" do
    it "returns a list of categories and items" do
      get api_v1_selectable_options_path

      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(2) # 1 category and 1 item without category
      expect(json_response[0]["name"]).to eq(category.name)
      expect(json_response[1]["name"]).to eq(item_without_category.name)
    end

    it 'redirects to sign in page if user is not signed in' do
      sign_out user

      get api_v1_selectable_options_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
