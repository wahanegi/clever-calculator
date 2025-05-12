require 'rails_helper'

RSpec.describe "Api::V1::QuoteItems", type: :request do
  let!(:user) { create :user }
  let!(:customer) { create :customer }
  let!(:quote) { create :quote, customer: customer, user: user }
  let!(:item) { create :item, category: nil }
  let!(:category) { create(:category) }
  let!(:items) { create_list :item, 2, category: category }

  let(:json_response) { response.parsed_body }
  let(:valid_params) { { quote: { customer_id: customer.id, total_price: 0, step: 'customer_info' } } }
  let(:invalid_params) { { quote: { customer_id: nil, total_price: -10, step: nil } } }

  before { sign_in user }

  describe "GET /api/v1/quotes/:quote_id/quote_items" do
    let!(:quote_item) { create(:quote_item, quote: quote, item: item) }

    it "returns a list of quote items and is successful" do
      get api_v1_quote_quote_items_path(quote)

      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
    end
  end

  describe "POST /api/v1/quotes/:quote_id/quote_items/create_from_item" do
    it 'creates a new quote item from an item' do
      post create_from_item_api_v1_quote_quote_items_path(quote), params: { quote_item: { item_id: item.id } }

      expect(response).to have_http_status(:created)
      expect(json_response["data"]["attributes"]["item"]['id']).to eq(item.id)
    end
  end

  describe 'POST /api/v1/quotes/:quote_id/quote_items/create_from_category' do
    it 'creates a new quote items from a category' do
      post create_from_category_api_v1_quote_quote_items_path(quote), params: { quote_item: { category_id: category.id } }

      expect(response).to have_http_status(:created)
      expect(json_response["data"].size).to eq(2)
    end
  end

  describe "DELETE /api/v1/quotes/:quote_id/quote_items/destroy_selected" do
    let!(:quote_items) { items.map { |item| create(:quote_item, quote: quote, item: item) } }
    let(:ids) { quote_items.map(&:id) }

    it 'destroys selected quote items by id' do
      expect(quote.quote_items.size).to eq(2)

      delete destroy_selected_api_v1_quote_quote_items_path(quote), params: { quote_item_ids: [ids.first] }

      expect(response).to have_http_status(:no_content)
      expect(quote.quote_items.size).to eq(1)
      expect(quote.quote_items.ids).not_to include(ids.first)
    end
  end

  describe "PATCH /api/v1/quotes/:quote_id/quote_items/:id" do
    context "with discount" do
      let!(:item_fixed) { create(:item, :with_fixed_parameters) }
      let!(:quote_item) { create(:quote_item, quote: quote, item: item_fixed) }

      it 'updates the quote item' do
        patch api_v1_quote_quote_item_path(quote, quote_item), params: { quote_item: { discount: 10 } }

        expect(response).to have_http_status(:ok)
        expect(json_response["data"]["attributes"]["discount"]).to eq('10.0')
      end
    end

    context "with open parameters" do
      let!(:item_open) { create(:item, :with_open_parameters) }
      let!(:quote_item) { create(:quote_item, quote: quote, item: item_open) }
      let(:valid_open_param_values) { { 'Custom' => '10' } }

      it 'updates the quote item' do
        patch api_v1_quote_quote_item_path(quote, quote_item), params: { quote_item: { open_param_values: valid_open_param_values } }

        expect(response).to have_http_status(:ok)
        expect(json_response["data"]['attributes']['pricing_parameters']).to eq(valid_open_param_values)
      end
    end

    context 'with select parameters' do
      let!(:item_select) { create(:item, :with_pricing_options) }
      let!(:quote_item) { create(:quote_item, quote: quote, item: item_select) }
      let(:valid_select_param_values) { { 'Tier' => '100' } }

      it 'updates the quote item' do
        patch api_v1_quote_quote_item_path(quote, quote_item), params: { quote_item: { select_param_values: valid_select_param_values } }

        expect(response).to have_http_status(:ok)
        expect(json_response["data"]['attributes']['pricing_parameters']).to eq(valid_select_param_values)
      end
    end
  end
end
