ActiveAdmin.register Quote do
  permit_params :customer_id, :user_id, category_ids: [],
                                        quote_items_attributes: [:id,
                                                                 :_destroy,
                                                                 :quote_id,
                                                                 :item_id,
                                                                 :open_parameters,
                                                                 :price,
                                                                 :discount,
                                                                 :final_price]

  filter :customer_name, as: :string, label: 'Customer Name'
  filter :user, as: :select, collection: proc {
    User.joins(:quotes).distinct.order(:email).map do |u|
      ["#{u.email} (#{u.name})", u.id]
    end
  }

  index do
    selectable_column
    id_column
    column 'Customer Name' do |quote|
      quote.customer.company_name
    end
    column 'Created By' do |quote|
      quote.user.name
    end
    column :total_price
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :customer, as: :select, collection: Customer.pluck(:company_name, :id)
      f.input :user, as: :select, collection: User.order(:email).map { |u| ["#{u.email} (#{u.name})", u.id] }
      f.input :categories, as: :check_boxes, collection: Category.pluck(:name, :id)
    end
    div do
      button_tag 'Load Items from Category', type: 'button', id: 'load-items-button', class: 'button'
    end
    f.actions
    # JS to load items dynamically
    script do
      raw <<-JS
    document.addEventListener("DOMContentLoaded", function () {
      const button = document.getElementById("load-items-button");
      button?.addEventListener("click", function () {
        const selectedCategories = Array.from(document.querySelectorAll("input[name='quote[category_ids][]']:checked")).map(cb => cb.value);

        if (selectedCategories.length === 0) {
          alert("Please select at least one category.");
          return;
        }

        fetch("/admin/quotes/load_items_from_categories", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content")
          },
          body: JSON.stringify({ category_ids: selectedCategories })
        })
        .then(response => response.json())
        .then(items => {
          const container = document.querySelector(".has_many_container.quote_items");

          items.forEach(item => {
            const addButton = container.querySelector(".has_many_add");
            addButton.click();

            setTimeout(() => {
              const lastItemGroup = container.querySelectorAll(".has_many_fields").item(-1);
              const itemSelect = lastItemGroup.querySelector("select[id$='_item_id']");
              const openParams = lastItemGroup.querySelector("input[id$='_open_parameters']");
              const discount = lastItemGroup.querySelector("input[id$='_discount']");

              if (itemSelect) {
                itemSelect.value = item.item_id;
              }
              if (openParams) {
                openParams.value = item.open_parameters;
              }
              if (discount) {
                discount.value = item.discount;
              }
            }, 100);
          });
        });
      });
    });
      JS
    end
  end

  show do
    attributes_table do
      row 'Customer Name' do |quote|
        quote.customer.company_name
      end
      row 'Created By' do |quote|
        quote.user.name
      end
      row :total_price
      row :created_at
    end
    panel 'Quote Items' do
      table_for quote.quote_items do
        column :item
        column :open_parameters
        column :price
        column :discount
        column :final_price
      end
    end
  end

  collection_action :load_items_from_categories, method: :post do
    category_ids = params[:category_ids] || []
    items = Item.where(category_id: category_ids)

    render json: items.map { |item|
      {
        category_id: item.category_id,
        item_id: item.id,
        item_name: item.name,
        open_parameters: '',
        discount: 0
      }
    }
  end
end
