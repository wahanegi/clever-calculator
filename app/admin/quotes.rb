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
      qf.object.restore_temp_fields if qf.object.respond_to?(:restore_temp_fields)

      qf.input :item_id, as: :hidden, input_html: { class: 'item-id-field' }
      qf.object.item ||= Item.find_by(id: qf.object.item_id)

      qf.template.concat(
        qf.template.content_tag(:div) do
          qf.template.content_tag(:label, 'Item Name', class: 'item-name-label') +
          qf.template.content_tag(:span, qf.object.item&.name || '', class: 'item-name-field', data: { item_name: qf.object.item&.name }) +
          qf.template.tag(:br) +
          qf.template.content_tag(:label, 'Category', class: 'item-name-label') +
          qf.template.content_tag(:span, qf.object.item&.category&.name || 'Other', class: 'category-name-field') +
          qf.template.tag(:br)
        end
      )

      if qf.object.item.present?
        fixed_parameters = qf.object.item.fixed_parameters || {}
        open_parameters_label = qf.object.item.open_parameters_label || []
        select_parameters = qf.object.item.pricing_options || {}

        qf.template.concat(
          qf.template.content_tag(:div, class: 'quote-parameters-container') do
            qf.template.content_tag(:label, 'Pricing parameters', class: 'item-name-label') +
            qf.template.render(
              partial: "admin/quotes/quote_item_parameters",
              locals: {
                fixed_parameters: fixed_parameters,
                open_parameters_label: open_parameters_label,
                select_parameters: select_parameters,
                quote_item: qf.object
              }
            )
          end
        )
      else
        qf.template.concat(
          qf.template.content_tag(:div, class: 'quote-parameters-container') do
            qf.template.content_tag(:label, 'Pricing parameters', class: 'item-name-label') +
            qf.template.content_tag(:div, '', class: 'quote-parameters-preview')
          end
        )
      end

      qf.input :price, as: :number, input_html: { min: 0, readonly: true, value: qf.object.price || 0, class: 'read-only-price' }, hint: 'Price will be calculated automatically based on Pricing parameters'
      qf.input :discount, as: :number, input_html: { min: 0 }
      qf.input :final_price, as: :number, input_html: { min: 0, readonly: true, value: qf.object.final_price || 0, class: 'read-only-price' }, hint: 'Final price will be calculated automatically based on Discount'

      qf.template.concat(
        qf.template.content_tag(:div, class: 'has_many_buttons') do
          qf.template.button_tag('Add Same Item', type: 'button', class: 'button add-same-item') +
          qf.template.link_to('Remove', '#', class: 'button has_many_remove')
        end
      )
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

  controller do
    def new
      if params[:quote] && params[:quote][:quote_items_attributes]
        params[:quote][:quote_items_attributes].each do |key, quote_item_params|
          next unless resource.quote_items[key.to_i]

          if quote_item_params[:open_param_values]
            resource.quote_items[key.to_i].open_param_values = quote_item_params[:open_param_values]
          end
          if quote_item_params[:select_param_values]
            resource.quote_items[key.to_i].select_param_values = quote_item_params[:select_param_values]
          end
        end
      end
      super
    end

    def create
      super
    rescue ActiveRecord::RecordInvalid
      if params[:quote] && params[:quote][:quote_items_attributes]
        params[:quote][:quote_items_attributes].each do |key, quote_item_params|
          next unless resource.quote_items[key.to_i]

          if quote_item_params[:open_param_values]
            resource.quote_items[key.to_i].open_param_values = quote_item_params[:open_param_values]
          end
          if quote_item_params[:select_param_values]
            resource.quote_items[key.to_i].select_param_values = quote_item_params[:select_param_values]
          end
        end
      end
      render :new
    end

    def edit
      Rails.logger.debug "[EDIT] Starting edit for Quote ##{resource.id}"

      resource.quote_items.each_with_index do |quote_item, idx|
        Rails.logger.debug "[EDIT] QuoteItem ##{idx} ID=#{quote_item.id} item_id=#{quote_item.item_id}"

        quote_item.item ||= Item.find_by(id: quote_item.item_id)

        if quote_item.item
          Rails.logger.debug "[EDIT] Loaded Item: #{quote_item.item.name}"
          quote_item.restore_temp_fields
        else
          Rails.logger.warn "[EDIT] No Item found for QuoteItem ##{idx}"
        end

        Rails.logger.debug "[EDIT] open_param_values after restore: #{quote_item.open_param_values.inspect}"
        Rails.logger.debug "[EDIT] select_param_values after restore: #{quote_item.select_param_values.inspect}"
      end

      super
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
    dummy_quote_item = QuoteItem.new(item: item)
    render partial: "admin/quotes/quote_item_parameters", locals: {
      fixed_parameters: item.fixed_parameters || {},
      open_parameters_label: item.open_parameters_label || [],
      select_parameters: item.pricing_options || {},
      quote_item: dummy_quote_item
    }
  end
end
