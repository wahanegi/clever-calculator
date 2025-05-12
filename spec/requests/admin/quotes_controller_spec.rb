require 'rails_helper'

RSpec.describe "Admin::Quotes", type: :request do
  let!(:admin_user) { create(:admin_user) }
  let!(:customer) { create(:customer) }
  let!(:user) { create(:user) }
  let!(:category) { create(:category) }
  let!(:item_fixed) { create(:item, :with_fixed_parameters, category: category, name: "Fixed Item") }
  let!(:item_open) { create(:item, :with_open_parameters, category: category, name: "Open Item") }
  let!(:item_select) { create(:item, :with_pricing_options, name: "Select Item", category: nil) }
  let!(:quote) { create(:quote, customer: customer, user: user) }
  let!(:quote_item) { create(:quote_item, quote: quote, item: item_fixed, price: 2500, discount: 10, final_price: 2250) }
  let(:unescaped_response_body) { CGI.unescapeHTML(response.body) }

  before do
    sign_in admin_user
  end

  describe "GET /admin/quotes (Index)" do
    it "renders the index page successfully" do
      get admin_quotes_path
      expect(response).to be_successful
      expect(unescaped_response_body).to include("Quotes")
      expect(unescaped_response_body).to include(customer.company_name)
      expect(unescaped_response_body).to include(user.name)
      expect(unescaped_response_body).to include(quote.total_price.to_s)
    end
  end

  describe "GET /admin/quotes/:id (Show)" do
    it "renders the show page successfully" do
      get admin_quote_path(quote)
      expect(response).to be_successful
      expect(unescaped_response_body).to include(customer.company_name)
      expect(unescaped_response_body).to include(user.name)
      expect(unescaped_response_body).to include("Quote Items")
      expect(unescaped_response_body).to include(item_fixed.name)
      expect(unescaped_response_body).to include("2500")
      expect(unescaped_response_body).to include("10")
      expect(unescaped_response_body).to include("2250")
    end
  end

  describe "GET /admin/quotes/new" do
    it "renders the new quote form successfully" do
      get new_admin_quote_path
      expect(response).to be_successful
      expect(response.body).to include("New Quote")
      expect(response.body).to include("Customer")
      expect(response.body).to include("Categories")
      expect(response.body).to include("Items Without Category")
      expect(response.body).to include("Load Items")
      expect(response.body).to include("Quote Items")
    end
  end

  describe "POST /admin/quotes (Create)" do
    let(:valid_attributes) do
      {
        customer_id: customer.id,
        user_id: user.id,
        quote_items_attributes: {
          "0" => {
            item_id: item_open.id,
            discount: "5",
            open_param_values: { "Custom" => "123" }
          }
        }
      }
    end

    let(:invalid_attributes) do
      { user_id: user.id }
    end

    context "with valid parameters" do
      it "creates a new Quote and associated QuoteItem" do
        expect do
          post admin_quotes_path, params: { quote: valid_attributes }
        end.to change(Quote, :count).by(1).and change(QuoteItem, :count).by(1)

        expect(response).to redirect_to(admin_quote_path(Quote.last))
        expect(flash[:notice]).to eq("Quote was successfully created.")

        new_quote = Quote.last
        expect(new_quote.customer).to eq(customer)
        expect(new_quote.user).to eq(user)
        new_item = new_quote.quote_items.first
        expect(new_item.item).to eq(item_open)
        expect(new_item.discount).to eq(5)
        expect(new_item.pricing_parameters["Custom"]).to eq("123")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Quote" do
        expect do
          post admin_quotes_path, params: { quote: invalid_attributes }
        end.not_to change(Quote, :count)
      end
    end
  end

  describe "GET /admin/quotes/:id/edit" do
    it "renders the edit quote form successfully" do
      get edit_admin_quote_path(quote)
      expect(response).to be_successful
      expect(response.body).to include("Edit Quote")
      expect(response.body).to include(customer.company_name)
      expect(response.body).to include("item-id-field")
      expect(response.body).to include("value=\"#{item_fixed.id}\"")
    end
  end

  describe "PATCH /admin/quotes/:id (Update)" do
    let!(:quote_to_update) { create(:quote, customer: customer, user: user) }
    let!(:existing_item) { create(:quote_item, quote: quote_to_update, item: item_fixed, discount: 10) }
    let!(:item_to_delete) do
      create(:quote_item,
             quote: quote_to_update,
             item: item_open,
             discount: 5,
             open_param_values: { "Custom" => "100" })
    end

    let(:update_attributes) do
      other_customer = create(:customer)
      {
        customer_id: other_customer.id,
        quote_items_attributes: {
          "0" => {
            id: existing_item.id,
            item_id: item_fixed.id,
            discount: "20"
          },
          "1" => {
            item_id: item_select.id,
            discount: "0",
            select_param_values: { "Tier" => "100" }
          },
          "2" => {
            id: item_to_delete.id,
            _destroy: "1"
          }
        }
      }
    end

    let(:invalid_update_attributes) do
      {
        customer_id: customer.id,
        quote_items_attributes: {
          "0" => {
            id: existing_item.id,
            item_id: item_fixed.id,
            discount: "-5"
          }
        }
      }
    end

    context "with valid parameters via custom controller action" do
      it "updates the Quote and processes QuoteItems correctly" do
        expect do
          patch admin_quote_path(quote_to_update), params: { quote: update_attributes }
          existing_item.reload
          quote_to_update.reload
        end.to change { quote_to_update.customer }.to(Customer.find(update_attributes[:customer_id]))
                                                  .and change { existing_item.discount }.to(20)
                                                                                        .and change { quote_to_update.quote_items.count }.by(0)

        expect(response).to redirect_to(admin_quote_path(quote_to_update))
        expect(flash[:notice]).to eq("Quote updated successfully.")

        new_item = quote_to_update.quote_items.find_by(item_id: item_select.id)
        expect(new_item).not_to be_nil
        expect(new_item.pricing_parameters["Tier"]).to eq("100")

        expect(QuoteItem.find_by(id: item_to_delete.id)).to be_nil
      end
    end

    context "with invalid parameters for a quote item" do
      it "does not update the quote and re-renders edit" do
        initial_discount = existing_item.discount
        patch admin_quote_path(quote_to_update), params: { quote: invalid_update_attributes }

        expect(response).to have_http_status(:ok)

        existing_item.reload
        expect(existing_item.discount).to eq(initial_discount)
      end
    end
  end

  describe "DELETE /admin/quotes/:id (Destroy)" do
    let!(:quote_to_destroy) { create(:quote, customer: customer, user: user) }
    let!(:item_in_quote) { create(:quote_item, quote: quote_to_destroy, item: item_fixed) }

    it "destroys the requested quote and its items" do
      expect do
        delete admin_quote_path(quote_to_destroy)
      end.to change(Quote, :count).by(-1).and change(QuoteItem, :count).by(-1)

      expect(response).to redirect_to(admin_quotes_path)
      expect(flash[:notice]).to eq("Quote was successfully destroyed.")
    end
  end
end
