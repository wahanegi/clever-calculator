require 'rails_helper'

RSpec.describe "Admin::CategoriesController", type: :request do
  before do
    sign_in create(:admin_user), scope: :admin_user
  end

  after do
    sign_out :admin_user
  end

  describe "GET /admin/categories" do
    it "returns http success" do
      get admin_categories_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PUT /admin/categories/:id/toggle" do
    let!(:category) { create(:category) }

    it "toggles category to disabled" do
      category.update(is_disabled: false)

      put toggle_admin_category_path(category)
      follow_redirect!
      category.reload

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Category was successfully disabled')
      expect(category.is_disabled).to be(true)
    end

    it "toggles category to enabled" do
      category.update(is_disabled: true)

      put toggle_admin_category_path(category)
      follow_redirect!
      category.reload

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Category was successfully enabled')
      expect(category.is_disabled).to be(false)
    end
  end

  describe 'POST /admin/categories' do
    it 'checks redirect to the categories page and successfully creates a category' do
      post admin_categories_path, params: { category: { name: 'Category', description: 'Description' } }

      expect(response).to redirect_to(admin_categories_path)

      follow_redirect!

      category = Category.last

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Category was successfully created')
      expect(category.name).to eq('Category')
      expect(category.description).to eq('Description')
    end
  end

  describe 'GET /admin/categories/new' do
    it 'returns http success' do
      get new_admin_category_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /admin/categories/:id/edit' do
    let!(:category) { create(:category) }

    it 'returns http success' do
      get edit_admin_category_path(category)

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /admin/categories/:id' do
    let!(:category) { create(:category) }

    it 'checks redirect to the category page and successfully updates the name and description' do
      put admin_category_path(category), params: { category: { name: 'Category', description: 'Description' } }

      expect(response).to redirect_to(admin_category_path(category))

      follow_redirect!

      category.reload # reload the category after the update

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Category was successfully updated')
      expect(category.name).to eq('Category')
      expect(category.description).to eq('Description')
    end
  end

  describe 'PATCH /admin/categories/:id' do
    let!(:category) { create(:category) }

    it 'checks redirect to the category page and successfully updates the name and description' do
      patch admin_category_path(category), params: { category: { name: 'Category', description: 'Description' } }

      expect(response).to redirect_to(admin_category_path(category))

      follow_redirect!

      category.reload # reload the category after the update

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Category was successfully updated')
      expect(category.name).to eq('Category')
      expect(category.description).to eq('Description')
    end
  end

  describe 'GET /admin/categories/:id' do
    let!(:category) { create(:category) }

    it 'returns http success' do
      get admin_category_path(category)

      expect(response).to have_http_status(:ok)
    end
  end
end
