ActiveAdmin.register Item do
  permit_params :name, :description, :pricing_type, :category_id, :is_disabled,
                item_pricings_attributes: [
                  :id, :default_fixed_price, :fixed_parameters, :is_selectable_options,
                  :pricing_options, { open_parameters_label: [] }, :open_parameters_label_as_string,
                  :formula_parameters, :calculation_formula, :is_open, :_destroy
                ]

  filter :name_cont, as: :string, label: "Product Name"
  filter :category, as: :select, collection: -> { Category.pluck(:name, :id) }, label: "Category"
  filter :pricing_type, as: :select, collection: Item.pricing_types, label: "Pricing Type"
  filter :is_disabled, label: "Disabled"

  index do
    id_column
    column :name
    column :pricing_type
    column "Category", sortable: :category_id do |item|
      link_to item.category.name, admin_category_path(item.category) if item.category
    end
    column("Disabled") { |item| status_tag item.is_disabled, label: item.is_disabled? ? "True" : "False" }
    column :created_at
    column :updated_at
    actions defaults: false do |resource|
      item("View", admin_item_path(resource), class: "member_link")
      item("Edit", edit_admin_item_path(resource), class: "member_link")
      item(resource.is_disabled? ? "Enable" : "Disable", toggle_admin_item_path(resource),
           method: :put,
           data: { confirm: "Are you sure?" },
           class: "member_link")
    end
  end

  actions :all, except: :destroy

  form do |f|
    f.semantic_errors

    f.inputs "Item Details" do
      f.input :name, required: true
      f.input :description
      f.input :category_id, as: :select,
                            collection: Category.pluck(:name, :id),
                            include_blank: "No Category"
      f.input :pricing_type, as: :radio, input_html: { onclick: "updatePricingType(this.value)" }
    end

    pricing = if f.object.fixed_open? && !f.object.persisted?
                nil
              else
                f.object.item_pricings.first_or_initialize
              end

    div id: "pricing_fixed", style: "display:#{f.object.fixed? ? 'block' : 'none'};" do
      f.inputs "Pricing parameter" do
        f.fields_for :item_pricings, pricing do |pf|
          pf.input :default_fixed_price, label: "Fixed Price"
        end
      end
    end
    div id: "pricing_open", style: "display:#{f.object.open? ? 'block' : 'none'};" do
      f.inputs "Pricing parameter" do
        f.fields_for :item_pricings, pricing do |pf|
          pf.input :open_parameters_label_as_string,
                   as: :text,
                   label: "Parameters name",
                   input_html: { rows: 1, value: pf.object.open_parameters_label_as_string }
        end
      end
    end
    div id: "pricing_fixed_open", style: "display:#{f.object.fixed_open? ? 'block' : 'none'};" do
      if f.object.persisted?
        f.inputs "Fixed + Open Pricing" do
          f.fields_for :item_pricings, pricing do |pf|
            pf.input :formula_parameters, as: :text, label: "Formula Parameters (JSON)"
            pf.input :calculation_formula, label: "Calculation Formula"
          end

          session_data = controller.view_context.session
          tmp_params = session_data[:tmp_params] || {}
          item_key = f.object.id.to_s
          tmp_data = tmp_params[item_key]&.deep_symbolize_keys || {}

          Rails.logger.debug "EDIT_FORM tmp_data: #{tmp_data.inspect}"

          tmp_fixed = tmp_data[:fixed] || {}
          tmp_open = tmp_data[:open] || []
          tmp_select = tmp_data[:select] || {}

          panel "Parameters" do
            if tmp_fixed.any?
              h3 "Fixed Parameters"
              table class: 'parameter-table' do
                tr do
                  th "Name"
                  th "Value"
                  th "Actions"
                end
                tmp_fixed.each do |name, value|
                  tr do
                    td name
                    td value
                    td do
                      link_to("Delete", remove_parameter_admin_item_path(f.object, param_type: :fixed, param_key: name.to_s),
                              method: :delete, data: { confirm: "Delete fixed param '#{name}'?" })
                    end
                  end
                end
              end
            else
              para "No fixed parameters."
            end

            if tmp_open.any?
              h3 "Open Parameters"
              table class: 'parameter-table' do
                tr do
                  th "Name"
                  th "Value"
                  th "Actions"
                end
                tmp_open.each do |label|
                  tr do
                    td label
                    td "Value is entered by the user"
                    td do
                      link_to("Delete", remove_parameter_admin_item_path(f.object, param_type: :open, param_key: label),
                              method: :delete, data: { confirm: "Delete open param '#{label}'?" })
                    end
                  end
                end
              end
            else
              para "No open parameters."
            end

            if tmp_select.any?
              h3 "Select Parameters"
              tmp_select.each do |sel_name, options|
                h4 do
                  text_node "Select name: #{sel_name}"
                  text_node " "
                  text_node link_to("[Delete #{sel_name} parameter]", remove_parameter_admin_item_path(f.object, param_type: :select, param_key: sel_name),
                                    method: :delete, data: { confirm: "Delete whole select '#{sel_name}' and its options?" })
                end
                table class: 'parameter-table' do
                  tr do
                    th "Options"
                    th "Value"
                    th "Actions"
                  end
                  options.each do |desc, val|
                    tr do
                      td desc
                      td val
                      td do
                        link_to("Delete", remove_parameter_admin_item_path(f.object, param_type: :select, param_key: sel_name, desc_key: desc),
                                method: :delete, data: { confirm: "Delete option '#{desc}' from select '#{sel_name}'?" })
                      end
                    end
                  end
                end
              end
            else
              para "No select parameters."
            end
          end
        end
      else
        panel "After creating this item, you will be redirected to edit page where you can add parameters."
      end
    end

    f.actions
  end

  controller do
    before_action :init_session_from_db, only: :edit
    def init_session_from_db
      @item = Item.find(params[:id])
      return unless @item.fixed_open?

      item_key = @item.id.to_s
      session[:tmp_params] ||= {}

      Rails.logger.debug "INIT_SESSION: before => #{session[:tmp_params][item_key].inspect}"

      unless session[:tmp_params].key?(item_key)
        pricing = @item.item_pricings.first
        session[:tmp_params][item_key] = if pricing
                                           {
                                             fixed: pricing.fixed_parameters || {},
                                             open: pricing.open_parameters_label || [],
                                             select: pricing.pricing_options || {}
                                           }
                                         else
                                           { fixed: {}, open: [], select: {} }
                                         end
      end
      Rails.logger.debug "INIT_SESSION: after => #{session[:tmp_params][item_key].inspect}"
    end

    def create
      Rails.logger.debug "SESSION: #{session[:tmp_params].inspect}"
      @item = Item.new(permitted_params[:item])
      if @item.save
        if @item.fixed_open?
          redirect_to edit_admin_item_path(@item), notice: "Item was successfully created. Now you can add parameters."
        else
          redirect_to admin_item_path(@item), notice: "Item was successfully created."
        end
      else
        flash.now[:error] = "Failed to create item: #{@item.errors.full_messages.to_sentence}"
        render :new, status: :unprocessable_entity
      end
    end

    def update
      Rails.logger.debug "SESSION: #{session[:tmp_params].inspect}"
      @item = Item.find(params[:id])
      item_key = @item.id.to_s
      tmp = (session[:tmp_params][item_key] || {}).deep_symbolize_keys

      item_params = permitted_params[:item].to_h

      if @item.fixed_open?
        item_params.delete("item_pricings_attributes")
        @item.assign_attributes(item_params)
        pricing = @item.item_pricings.first_or_initialize

        pricing.fixed_parameters = tmp[:fixed] || {}
        Rails.logger.debug "before assign => tmp[:open] = #{tmp[:open].inspect}"
        pricing.open_parameters_label = tmp[:open] || []
        Rails.logger.debug "after assign => pricing.open_parameters_label = #{pricing.open_parameters_label.inspect}"
        pricing.pricing_options = tmp[:select] || {}

        pricing.is_open = pricing.open_parameters_label.any?
        pricing.is_selectable_options = pricing.pricing_options.any?

        Rails.logger.debug "DEBUG before pricing.save => open_parameters_label: #{pricing.open_parameters_label.inspect}"
        unless pricing.save
          Rails.logger.debug "Pricing save errors: #{pricing.errors.full_messages}"
          flash[:error] = "Failed to update pricing: #{pricing.errors.full_messages.join(', ')}"
          return render :edit
        end
      else
        @item.assign_attributes(item_params)
      end

      if @item.save
        session[:tmp_params].delete(item_key)
        redirect_to admin_item_path(@item), notice: "Item parameter updated!"
      else
        flash[:error] = "Failed to update item: #{@item.errors.full_messages.join(', ')}"
        render :edit
      end
    end
  end

  member_action :remove_parameter, method: :delete do
    @item = Item.find(params[:id])
    item_key = @item.id.to_s

    session[:tmp_params] ||= {}
    session[:tmp_params][item_key] ||= { fixed: {}, open: [], select: {} }
    store = session[:tmp_params][item_key].deep_symbolize_keys
    session[:tmp_params][item_key] = store

    param_type = params[:param_type].to_s
    key = params[:param_key].to_s
    desc_key = params[:desc_key].to_s if params[:desc_key].present?

    Rails.logger.debug "REMOVE_PARAM: param_type=#{param_type}, param_key=#{key}, desc_key=#{desc_key}"
    Rails.logger.debug "STORE BEFORE DELETE: #{store.inspect}"

    case param_type
    when "fixed"
      store[:fixed]&.delete(key.to_sym)
    when "open"
      store[:open]&.delete(key)
    when "select"
      if desc_key.present?
        store[:select][key]&.delete(desc_key)
      else
        store[:select]&.delete(key)
      end
    else
      Rails.logger.warn "⚠️ Unknown param_type: #{param_type}"
    end

    Rails.logger.debug "STORE AFTER DELETE: #{store.inspect}"
    flash[:notice] = "Parameter removed."
    redirect_to edit_admin_item_path(@item)
  end

  action_item :add_parameter, only: :edit do
    link_to("Add Parameter", new_parameter_admin_item_path(resource)) if resource.fixed_open?
  end

  member_action :new_parameter, method: :get do
    @item = Item.find(params[:id])
  end

  member_action :create_parameter, method: :post do
    Rails.logger.debug "SESSION: #{session[:tmp_params].inspect}"
    @item = Item.find(params[:id])
    item_key = @item.id.to_s

    session[:tmp_params] ||= {}
    session[:tmp_params][item_key] ||= { fixed: {}, open: [], select: {} }
    store = session[:tmp_params][item_key]
    store = store.deep_symbolize_keys
    session[:tmp_params][item_key] = store
    Rails.logger.info "DEBUG create_parameter: store before => #{store.inspect}"

    case params[:parameter_type]
    when "Fixed"
      store[:fixed][params[:fixed_parameter_name]] = params[:fixed_parameter_value]
      Rails.logger.debug "STORE after Fixed: #{store.inspect}"
    when "Open"
      Rails.logger.debug "CREATE_PARAM: before open => #{store[:open].inspect}"
      store[:open] << params[:open_parameter_name].to_s
      Rails.logger.debug "STORE after Open: #{store.inspect}"
    when "Select"
      sub_hash = {}
      (1..10).each do |i|
        desc = params["option_description_#{i}"]
        val = params["option_value_#{i}"]
        next if desc.blank? || val.blank?

        sub_hash[desc] = val
      end
      store[:select][params[:select_parameter_name]] = sub_hash
      Rails.logger.debug "STORE after Select: #{store.inspect}"
    end

    flash[:notice] = "Parameter '#{params[:parameter_type]}' added (stored in session, not saved yet)."
    redirect_to edit_admin_item_path(@item)
  end

  action_item :back, only: :show do
    link_to "Back", admin_items_path
  end

  member_action :toggle, method: :put do
    resource.update(is_disabled: !resource.is_disabled)
    redirect_to admin_items_path, notice: "Item has been #{resource.is_disabled? ? 'disabled' : 'enabled'}."
  end

  action_item :toggle, only: :show do
    link_to(resource.is_disabled? ? "Enable item" : "Disable item", toggle_admin_item_path(resource),
            method: :put,
            data: { confirm: "Are you sure?" })
  end

  show do
    attributes_table do
      row :id
      row :name
      row :pricing_type
      row "Category" do |item|
        link_to item.category.name, admin_category_path(item.category) if item.category
      end
      row "Status" do |item|
        status_tag(item.is_disabled? ? "Disable" : "Enable", class: item.is_disabled? ? "red" : "green")
      end
      row :created_at
      row :updated_at
    end
  end
end
