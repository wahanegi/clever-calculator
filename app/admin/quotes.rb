ActiveAdmin.register Quote do
  permit_params :customer_id,
                :user_id,
                :contract_type_id,
                :contract_start_date,
                :contract_end_date,
                :total_price,
                quote_items_attributes: [:id,
                                         :item_id,
                                         :price,
                                         :discount,
                                         :final_price,
                                         :_destroy,
                                         :pricing_parameters,
                                         :open_param_values,
                                         :select_param_values,
                                         { note_attributes: [:id,
                                                             :notes,
                                                             :is_printable,
                                                             :_destroy] }]

  includes :user, :customer, :contract_type

  filter :customer_company_name, as: :string, label: 'Company Name'
  filter :user, as: :select, collection: proc {
    User.joins(:quotes).distinct.order(:email).map do |u|
      ["#{u.email} (#{u.name})", u.id]
    end
  }
  filter :contract_type, as: :select, collection: -> { ContractType.pluck(:name, :id) }

  index do
    selectable_column
    id_column
    column 'Company Name' do |quote|
      quote.customer.company_name
    end
    column 'Created By' do |quote|
      quote.user.name
    end
    column 'Total Price' do |quote|
      number_to_currency(quote.total_price)
    end
    column :contract_type
    column 'Contract Period', &:contract_period
    column :created_at
    actions
  end

  form html: { class: 'quote-form' } do |f|
    f.inputs do
      f.input :customer, as: :select, collection: Customer.pluck(:company_name, :id), input_html: { class: 'custom-select' }
      f.input :user, as: :select, collection: User.order(:name).pluck(:name, :id), input_html: { class: 'custom-select' }
      f.input :contract_type, as: :select, collection: ContractType.pluck(:name, :id), input_html: { class: 'custom-select' }
      render partial: 'admin/quotes/contract_period_fields', locals: { quote: f.object }
      f.inputs class: 'dropdown-group' do
        li class: 'dropdown-fieldset' do
          span class: 'fieldset-title' do
            text_node 'Categories'
          end

          li class: 'dropdown-wrapper check_boxes input optional', id: 'quote_category_ids_input' do
            fieldset class: 'choices' do
              div class: 'dropdown-toggle' do
                text_node 'Click to select categories...'
              end
              div class: 'selected-category-names' do
                text_node 'No categories selected'
              end

              div class: 'dropdown-content' do
                f.input :categories,
                        as: :check_boxes,
                        collection: Category.enabled
                                            .joins(:items)
                                            .where(items: { is_disabled: false })
                                            .distinct
                                            .order(:name)
                                            .pluck(:name, :id),
                        label: false,
                        input_html: { class: 'category-checkbox' }
              end
            end
          end
        end
      end

      f.inputs class: 'dropdown-group' do
        li class: 'dropdown-fieldset' do
          span class: 'fieldset-title' do
            text_node 'Items Without Category'
          end

          li class: 'dropdown-wrapper check_boxes input optional', id: 'quote_item_ids_input' do
            fieldset class: 'choices' do
              div class: 'dropdown-toggle' do
                text_node 'Click to select items...'
              end
              div class: 'selected-item-names' do
                text_node 'No items selected'
              end

              div class: 'dropdown-content' do
                f.input :item_ids,
                        as: :check_boxes,
                        collection: Item.enabled.where(category_id: nil).order(:name).pluck(:name, :id),
                        label: false,
                        input_html: { class: 'items-checkbox' }
              end
            end
          end
        end
      end

      f.input :total_price, as: :number, input_html: { min: 0, readonly: true, class: 'read-only-price' }, required: false, hint: 'Total price will be calculated automatically based on quote items.'
    end
    div do
      button_tag 'Load Items', type: 'button', id: 'load-items-button', class: 'button'
    end
    f.has_many :quote_items, allow_destroy: false, new_record: true, heading: 'Quote Items' do |qf|
      qf.input :item_id, as: :hidden, input_html: { class: 'item-id-field' }
      qf.input :id, as: :hidden if qf.object.persisted?
      qf.input :_destroy, as: :hidden, input_html: { value: '0', class: 'destroy-field' } if qf.object.persisted?

      if qf.object.pricing_parameters.present? && qf.object.item&.open_parameters_label.present?
        qf.object.item.open_parameters_label.each do |label|
          qf.template.concat qf.template.hidden_field_tag(
            "quote[quote_items_attributes][#{qf.index}][open_param_values][#{label}]",
            qf.object.pricing_parameters[label] || '',
            class: 'quote-open-param-input',
            data: { param_name: label }
          )
        end
      end

      if qf.object.pricing_parameters.present? && qf.object.item&.pricing_options.present?
        qf.object.item.pricing_options.each_key do |key|
          qf.template.concat qf.template.hidden_field_tag(
            "quote[quote_items_attributes][#{qf.index}][select_param_values][#{key}]",
            qf.object.pricing_parameters[key] || '',
            class: 'quote-select-param-input',
            data: { param_name: key }
          )
        end
      end

      qf.template.concat(
        qf.template.content_tag(:div, class: 'category-name-group') do
          qf.template.content_tag(:label, 'Category', class: 'category-name-label') +
            qf.template.content_tag(:span, qf.object.item&.category&.name || 'Without Category', class: 'category-name-field') +
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

      qf.input :price, as: :number, input_html: { min: 0, readonly: true, value: qf.object.price || 0, class: 'read-only-price' },
                       required: false, hint: 'Price will be calculated automatically based on Pricing parameters'
      qf.input :discount, as: :number, input_html: { min: 0, max: 100, class: 'discount-input' }
      qf.input :final_price, as: :number, input_html: { min: 0, readonly: true, value: qf.object.final_price || 0, class: 'read-only-price' },
                             required: false, hint: 'Final price will be calculated automatically based on Discount'
      qf.has_many :note, allow_destroy: true, new_record: true, heading: false, class: 'quote-item-note-wrapper' do |n|
        n.input :notes, as: :text, input_html: { class: 'note-textarea', rows: 6 }
        n.input :is_printable, as: :boolean, label: 'Is downloadable'
      end

      qf.template.concat(
        qf.template.content_tag(:div, class: 'has_many_buttons') do
          qf.template.button_tag('Add Same Item', type: 'button', class: 'button add-same-item') +
            qf.template.link_to('Remove Item', '#', class: 'button has_many_remove')
        end
      )
    end
    f.actions
  end

  show do
    attributes_table do
      row 'Company Name' do |quote|
        quote.customer.company_name
      end
      row 'Created By' do |quote|
        quote.user.name
      end
      row 'Contract Type' do |quote|
        quote.contract_type.name
      end
      row 'Contract Period', &:contract_period
      row 'Total Price' do |quote|
        number_to_currency(quote.total_price)
      end
      row :created_at
    end

    panel 'Quote Items' do
      table_for quote.quote_items do
        column :item
        column 'Pricing Parameters' do |quote_item|
          if quote_item.pricing_parameters.present?
            quote_item.pricing_parameters.map { |key, value| "#{key}: #{value}" }.join(" | ")
          else
            "-"
          end
        end
        column 'Price' do |quote_item|
          number_to_currency(quote_item.price)
        end
        column :discount
        column 'Final Price' do |quote_item|
          number_to_currency(quote_item.final_price)
        end
        column :note, class: 'col-note break-word' do |quote_item|
          quote_item&.note&.notes || 'No notes'
        end
        column 'Is note downloadable?' do |quote_item|
          quote_item&.note.nil? ? 'No notes' : quote_item.note.is_printable
        end
      end
    end
  end

  action_item :back, only: :show do
    link_to "Back To Quotes", admin_quotes_path
  end

  action_item :generate_file, only: :show do
    link_to "Download", generate_file_admin_quote_path(resource)
  end

  member_action :generate_file, method: :get do
    send_data QuoteDocxGenerator.new(resource).call,
              type: Mime[:docx],
              disposition: 'attachment',
              filename: "quote.docx"
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
        category_name: item.category&.name || 'Without Category',
        item_id: item.id,
        item_name: item.name,
        pricing_parameters: {
          fixed_parameters: item.fixed_parameters || {},
          open_parameters_label: item.open_parameters_label || [],
          pricing_options: item.pricing_options || {}
        },
        discount: 0,
        has_formula_parameters: item.formula_parameters.any?
      }
    }
  end

  collection_action :render_quote_item_parameters, method: :post do
    item = Item.find_by(id: params[:item_id])
    return head :not_found unless item

    allowed_open_keys = item.open_parameters_label || []
    allowed_select_keys = item.pricing_options&.keys || []

    open_param_values = extract_safe_params(params[:open_param_values], allowed_open_keys)
    select_param_values = extract_safe_params(params[:select_param_values], allowed_select_keys)

    render partial: "admin/quotes/quote_item_parameters", locals: {
      fixed_parameters: item.fixed_parameters || {},
      open_parameters_label: allowed_open_keys,
      select_parameters: item.pricing_options || {},
      open_param_values: open_param_values,
      select_param_values: select_param_values
    }
  end

  controller do
    helper ActiveAdmin::ItemsHelper
    before_action :sanitize_blank_arrays, only: %i[create update]

    def update
      @quote = Quote.find(params[:id])

      if @quote.update(quote_params)
        redirect_to admin_quote_path(@quote), notice: "Quote updated successfully."
      else
        render :edit
      end
    end

    def create
      @quote = Quote.new(quote_params)

      if @quote.save
        redirect_to admin_quote_path(@quote), notice: "Quote was successfully created."
      else
        render :new
      end
    end

    def sanitize_blank_arrays
      params[:quote]&.delete(:category_ids)
      params[:quote]&.delete(:item_ids)
    end

    private

    def quote_params
      quote_param = params[:quote].to_unsafe_h
      quote_items = quote_param['quote_items_attributes']
      updated_items = {}

      quote_items&.each do |key, qip|
        open = qip['open_param_values']
        select = qip['select_param_values']

        pricing = (open || {}).merge(select || {})
        qip['pricing_parameters'] = pricing
        updated_items[key] = qip
      end

      quote_param['quote_items_attributes'] = updated_items
      quote_param
    end

    def extract_safe_params(param_set, allowed_keys)
      return {} if param_set.blank?

      if param_set.is_a?(ActionController::Parameters)
        param_set.permit(*allowed_keys).to_h
      else
        param_set.to_h.slice(*allowed_keys)
      end
    end
  end
end
