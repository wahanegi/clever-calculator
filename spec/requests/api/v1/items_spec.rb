require 'rails_helper'

RSpec.describe 'Api::V1::Items', type: :request do
  describe 'GET /api/v1/items/uncategorized' do
    let!(:user) { create :user }
    let!(:uncategorized_item1) { create(:item, name: 'Uncategorized Item 1', category_id: nil) }
    let!(:uncategorized_item2) { create(:item, name: 'Uncategorized Item 2', category_id: nil) }
    let!(:categorized_item) { create(:item, name: 'Categorized Item 3') }
    let!(:disabled_item) { create(:item, name: 'Disable Item 4', category_id: nil, is_disabled: true) }
    let(:json_response) { response.parsed_body }

    before do
      sign_in user
      get '/api/v1/items/uncategorized'
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns only uncategorized and enabled items' do
      expect(json_response[:data].size).to eq(2)
      expect(json_response[:data].map { |item| item[:attributes][:name] }).to contain_exactly('Uncategorized Item 1', 'Uncategorized Item 2')
    end

    it 'excludes categorized items' do
      expect(json_response[:data].map { |item| item[:attributes][:name] }).not_to include('Categorized Item 3')
    end

    it 'excludes disabled items' do
      expect(json_response[:data].map { |item| item[:attributes][:name] }).not_to include('Disable Item 4')
    end

    it 'returns serialized items with expected attributes' do
      item = json_response[:data].first
      expect(item).to include(
        id: uncategorized_item1.id.to_s,
        type: 'item',
        attributes: hash_including(
          name: 'Uncategorized Item 1',
          category_id: nil,
          is_disabled: false
        )
      )
    end
  end
end
