ActiveAdmin.register Quote do
  permit_params :customer_id, :user_id, category_ids: [],
                                        quote_items_attributes: [:id,
                                                                 :_destroy,
                                                                 :quote_id,
                                                                 :item_id,
                                                                 :pricing_parameters,
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
      f.input :categories, as: :check_boxes,
                           collection: Category.order(:name).pluck(:name, :id) + [['Items without category', 'other']],
                           wrapper_html: { class: 'categories-wrapper' }
    end
    div do
      button_tag 'Load Items from Category', type: 'button', id: 'load-items-button', class: 'button'
    end
    f.actions
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
        column :pricing_parameters
        column :price
        column :discount
        column :final_price
      end
    end
  end

  collection_action :load_items_from_categories, method: :post do
    category_ids = params[:category_ids] || []

    items = Item.where(category_id: category_ids.reject { |id| id == 'other' })
    items += Item.where(category_id: nil) if category_ids.include?('other')

    render json: items.map { |item|
      {
        category_id: item.category_id,
        item_id: item.id,
        item_name: item.name,
        item_fixed_parameters: item.fixed_parameters,
        item_pricing_options: item.pricing_options,
        item_open_parameters_label: item.open_parameters_label,
        pricing_parameters: {},
        discount: 0
      }
    }
  end
end
