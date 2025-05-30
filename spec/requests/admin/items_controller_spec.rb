require 'rails_helper'

RSpec.describe 'Admin::Items', type: :request do
  let!(:admin_user) { create(:admin_user) }
  let!(:category) { create(:category) }
  let(:item) { create(:item, category: category) }

  before do
    sign_in admin_user
  end

  describe 'GET /admin/items' do
    let!(:items) { create_list(:item, 3, category: category) }

    it 'displays the index page with items' do
      get '/admin/items'
      expect(response).to have_http_status(:success)
      items.each do |item|
        expect(response.body).to include(item.name)
        expect(response.body).to include(item.category.name)
        expect(response.body).to include(item.is_disabled ? 'False' : 'True')
      end
    end
  end

  describe 'GET /admin/items/:id' do
    let(:item) do
      create(:item,
             category: category,
             fixed_parameters: { 'Platform Fee' => '1000' },
             open_parameters_label: ['Users'],
             pricing_options: {
               "Tier" => {
                 "options" => [ { "value" => "200", "description" => "Silver" } ],
                 "value_label" => "Cost Per User"
               }
             },
             calculation_formula: 'platform_fee * tier',
             formula_parameters: ["Platform fee", "Tier"])
    end

    it 'displays the item details with parameters and formula' do
      get "/admin/items/#{item.id}"
      expect(response).to have_http_status(:success)
      expect(response.body).to include(item.name)
      expect(response.body).to include(item.category.name)
      expect(response.body).to include('Platform Fee')
      expect(response.body).to include('1000')
      expect(response.body).to include('Users')
      expect(response.body).to include('Tier')
      expect(response.body).to include('Silver')
      expect(response.body).to include('200')
      expect(response.body).to include('Cost Per User')
      expect(response.body).to include('platform_fee * tier')
    end
  end

  describe 'POST /admin/items' do
    let(:valid_params) do
      {
        item: {
          name: 'Test Item',
          description: 'A test item',
          category_id: category.id
        }
      }
    end

    let(:valid_params_without_category) do
      {
        item: {
          name: 'Test Item',
          description: 'A test item'
        }
      }
    end

    let(:invalid_params) { { item: { name: '' } } }

    context 'when a category is' do
      it 'not selected and redirects to the item page' do
        expect do
          post admin_items_path, params: valid_params_without_category
        end.to change(Item, :count).by(1)

        expect(response).to redirect_to(admin_item_path(Item.last))

        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Test Item')
        expect(response.body).to include('Item was successfully created.')
      end

      it 'selected and redirects to the item page' do
        expect do
          post admin_items_path(category_id: category.id), params: valid_params
        end.to change(Item, :count).by(1)

        expect(response).to redirect_to(admin_item_path(Item.last))

        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Test Item')
        expect(response.body).to include('Item was successfully created.')
      end
    end

    context 'with session parameters' do
      before do
        # Set up session[:tmp_params] via create_parameter requests
        post '/admin/items/new/create_parameter', params: {
          parameter_type: 'Fixed',
          fixed_parameter_name: 'Acquisition',
          fixed_parameter_value: '2500'
        }

        post '/admin/items/new/create_parameter', params: {
          parameter_type: 'Open',
          open_parameter_name: 'Custom'
        }

        post '/admin/items/new/create_parameter', params: {
          parameter_type: 'Select',
          select_parameter_name: 'Tier',
          value_label: 'Cost Per User',
          select_options: [
            { description: '1-5', value: '100' }
          ]
        }

        post '/admin/items/new/update_formula', params: {
          calculation_formula: 'acquisition * tier + custom'
        }
      end

      it 'creates an item with session parameters and clears session' do
        expect do
          post '/admin/items', params: valid_params
        end.to change(Item, :count).by(1)

        item = Item.last
        expect(item.fixed_parameters).to eq('Acquisition' => '2500')
        expect(item.open_parameters_label).to eq(['Custom'])
        expect(item.pricing_options).to eq("Tier" => { "options" => [{ "description" => "1-5", "value" => "100" }], "value_label" => "Cost Per User" })
        expect(item.formula_parameters).to eq(%w[Acquisition Custom Tier])
        expect(item.calculation_formula).to eq('acquisition * tier + custom')
        expect(item.is_fixed).to be true
        expect(item.is_open).to be true
        expect(item.is_selectable_options).to be true
        expect(response).to redirect_to(admin_item_path(item))
      end

      it 'does not create an item with invalid params' do
        expect do
          post '/admin/items', params: invalid_params
        end.not_to change(Item, :count)

        expect(response.body).to include('Failed to create item')
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT /admin/items/:id' do
    let(:valid_params) do
      {
        item: {
          name: 'Updated Item',
          description: 'Updated description'
        }
      }
    end
    let(:valid_params_without_category) do
      {
        item: {
          name: 'Updated Item',
          description: 'Updated description',
          category_id: nil
        }
      }
    end
    let(:invalid_params) { { item: { name: '' } } }

    context 'when category is' do
      it 'selected and redirects to the item page' do
        put admin_item_path(item), params: valid_params

        expect(response).to redirect_to(admin_item_path(item))

        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Updated Item')
        expect(response.body).to include("Item was successfully updated.")
      end

      it 'not selected and redirects to the item page' do
        put admin_item_path(item), params: valid_params_without_category

        expect(response).to redirect_to(admin_item_path(item))

        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Updated Item')
        expect(response.body).to include("Item was successfully updated.")
      end
    end

    it 'updates the item and redirects' do
      put "/admin/items/#{item.id}", params: valid_params
      item.reload

      expect(item.name).to eq('Updated Item')
      expect(item.description).to eq('Updated description')
      expect(response).to redirect_to(admin_item_path(item))
      follow_redirect!
      expect(response.body).to include('Updated Item')
    end

    it 'does not update with invalid params and renders edit' do
      original_name = item.name
      put "/admin/items/#{item.id}", params: invalid_params
      item.reload

      expect(item.name).to eq(original_name)
      expect(response.body).to include('Failed to update item')
    end
  end

  describe 'PUT /admin/items/:id/toggle' do
    context 'when item is enabled' do
      it 'disables the item and redirects' do
        put "/admin/items/#{item.id}/toggle"
        item.reload
        expect(item.is_disabled).to be true
        expect(response).to redirect_to('/admin/items')
        expect(flash[:notice]).to eq('Item has been disabled.')
      end
    end

    context 'when item is disabled' do
      let(:item) { create(:item, category: category, is_disabled: true) }

      it 'enables the item and redirects' do
        put "/admin/items/#{item.id}/toggle"
        item.reload
        expect(item.is_disabled).to be false
        expect(response).to redirect_to('/admin/items')
        expect(flash[:notice]).to eq('Item has been enabled.')
      end
    end
  end

  describe 'DELETE /admin/items/:id/remove_parameter' do
    before do
      # Set up session[:tmp_params] via create_parameter requests
      post '/admin/items/new/create_parameter', params: {
        parameter_type: 'Fixed',
        fixed_parameter_name: 'Platform Fee',
        fixed_parameter_value: '2500'
      }

      post '/admin/items/new/create_parameter', params: {
        parameter_type: 'Open',
        open_parameter_name: 'Custom'
      }

      post '/admin/items/new/create_parameter', params: {
        parameter_type: 'Select',
        select_parameter_name: 'Tier',
        value_label: 'Cost Per User',
        select_options: [
          { description: '1-5', value: '100' }
        ]
      }

      post '/admin/items/new/update_formula', params: {
        calculation_formula: 'Platform Fee * Tier'
      }
    end

    it 'removes a fixed parameter' do
      delete "/admin/items/#{item.id}/remove_parameter", params: {
        param_type: 'fixed',
        param_key: 'Platform Fee'
      }
      expect(response).to redirect_to("/admin/items/#{item.id}/edit")
      get "/admin/items/#{item.id}/edit"
      expect(response.body).not_to include('Platform Fee')
    end

    it 'removes an entire select parameter' do
      delete "/admin/items/#{item.id}/remove_parameter", params: {
        param_type: 'select',
        param_key: 'Tier'
      }
      expect(response).to redirect_to("/admin/items/#{item.id}/edit")
      get "/admin/items/#{item.id}/edit"
      expect(response.body).not_to include('Tier')
    end
  end
end
