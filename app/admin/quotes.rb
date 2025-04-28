ActiveAdmin.register Quote do
  permit_params :customer_id, :user_id, :total_price,  category_ids: [], item_ids: [],
                                                       quote_items_attributes: [:id,
                                                                                :_destroy,
                                                                                :quote_id,
                                                                                :item_id,
                                                                                :pricing_parameters,
                                                                                { open_param_values: {} },
                                                                                { select_param_values: {} },
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

  form html: { class: 'quote-form' } do |f|
    f.inputs do
      f.input :customer, as: :select, collection: Customer.pluck(:company_name, :id)
      f.input :user, as: :select, collection: User.order(:name).pluck(:name, :id)
      f.input :categories, as: :check_boxes,
                           collection: Category.order(:name).pluck(:name, :id),
                           wrapper_html: { class: 'categories-wrapper' }
      f.input :item_ids, label: 'Items Without Category', as: :check_boxes, collection: Item.where(category_id: nil).order(:name),
                         wrapper_html: { class: 'categories-wrapper' }
      f.input :total_price, as: :number, input_html: { min: 0, readonly: true }, hint: 'Total price will be calculated automatically based on quote items.'
    end
    div do
      button_tag 'Load Items', type: 'button', id: 'load-items-button', class: 'button'
    end
    f.has_many :quote_items, allow_destroy: true, new_record: true, heading: 'Quote Items' do |qf|
      qf.input :item_id, as: :hidden, input_html: { class: 'item-id-field' }

      qf.template.concat(
        qf.template.content_tag(:div) do
          qf.template.content_tag(:label, 'Category', class: 'category-name-label') +
          qf.template.content_tag(:span, qf.object.item&.category&.name || 'Other', class: 'category-name-field') +
          qf.template.tag(:br) +
          qf.template.content_tag(:label, 'Item Name', class: 'item-name-label') +
          qf.template.content_tag(:span, qf.object.item&.name || '', class: 'item-name-field', data: { item_name: qf.object.item&.name })
        end
      )

      qf.template.concat(
        qf.template.content_tag(:div, class: 'quote-parameters-container') do
          qf.template.content_tag(:label, 'Pricing parameters', class: 'item-name-label') +
            qf.template.content_tag(:div, '', class: 'quote-parameters-preview')
        end
      )

      qf.input :price, as: :number, input_html: { min: 0, readonly: true, value: qf.object.price || 0, class: 'read-only-price' }, hint: 'Price will be calculated automatically based on Pricing parameters'
      qf.input :discount, as: :number, input_html: { min: 0 }
      qf.input :final_price, as: :number, input_html: { min: 0, readonly: true, value: qf.object.final_price || 0, class: 'read-only-price' }, hint: 'Final price will be calculated automatically based on Discount'
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
        column 'Pricing Parameters' do |quote_item|
          if quote_item.pricing_parameters.present?
            quote_item.pricing_parameters.map do |key, value|
              "#{key}: #{value}"
            end.join(" | ")
          else
            "-"
          end
        end
        column :price
        column :discount
        column :final_price
      end
    end
  end

  collection_action :load_items, method: :post do
    category_ids = params[:category_ids] || []
    item_ids = params[:item_ids] || []

    items = Item.none
    items = items.or(Item.where(category_id: category_ids)) if category_ids.any?
    items = items.or(Item.where(id: item_ids)) if item_ids.any?

    render json: items.map { |item|
      {
        category_id: item.category_id,
        category_name: item.category&.name || 'Other',
        item_id: item.id,
        item_name: item.name,
        pricing_parameters: {
          fixed_parameters: item.fixed_parameters || {},
          open_parameters_label: item.open_parameters_label || [],
          pricing_options: item.pricing_options || {}
        },
        discount: 0
      }
    }
  end

  collection_action :render_quote_item_parameters, method: :post do
    item = Item.find(params[:item_id])
    render partial: "admin/quotes/quote_item_parameters", locals: {
      fixed_parameters: item.fixed_parameters || {},
      open_parameters_label: item.open_parameters_label || [],
      select_parameters: item.pricing_options || {}
    }
  end
end
