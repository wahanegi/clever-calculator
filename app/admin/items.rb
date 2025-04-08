ActiveAdmin.register Item do
  permit_params :name, :description, :pricing_type, :category_id, :is_disabled,
                item_pricing_attributes: [
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

  form do |f|
    f.semantic_errors

    div id: "add-parameter-button-wrapper", style: "margin-top: 20px;" do
    end

    f.inputs "Item Details" do
      f.input :name, required: true
      f.input :description, as: :string
      f.input :category_id, as: :select,
                            collection: Category.pluck(:name, :id),
                            include_blank: "No Category"
      f.input :pricing_type, as: :radio, input_html: { onclick: "updatePricingType(this.value)" }
    end

    pricing = if f.object.fixed_open? && !f.object.persisted?
                nil
              else
                f.object.item_pricing || f.object.build_item_pricing
              end

    div id: "pricing_fixed", style: "display:#{f.object.fixed? ? 'block' : 'none'};" do
      f.inputs "Pricing parameter" do
        f.fields_for :item_pricing, pricing do |pf|
          pf.input :default_fixed_price, label: "Fixed Price"
        end
      end
    end
    div id: "pricing_open", style: "display:#{f.object.open? ? 'block' : 'none'};" do
      f.inputs "Pricing parameter" do
        f.fields_for :item_pricing, pricing do |pf|
          pf.input :open_parameters_label_as_string,
                   as: :text,
                   label: "Parameters name",
                   input_html: { rows: 1, value: pf.object.open_parameters_label_as_string }
        end
      end
    end
    div id: "pricing_fixed_open", style: "display:#{f.object.fixed_open? ? 'block' : 'none'};" do
      if f.object.fixed_open? && f.object.persisted?
        div class: "add-param-link-wrapper" do
          formula_label = pricing&.calculation_formula.present? ? "Update Calculation Formula" : "Create Calculation Formula"
          para do
            concat link_to("Add Parameter", new_parameter_admin_item_path(f.object), class: "button")
            concat link_to(formula_label, new_formula_admin_item_path(f.object), class: "button")
          end
        end
        f.inputs "Parameter Pricing" do
          f.fields_for :item_pricing, pricing do |pf|
            pf.input :formula_parameters, as: :hidden
            div class: "formula-preview" do
              span class: "formula-label" do
                "Calculation Formula:"
              end
              span class: "formula" do
                pricing.calculation_formula.presence || "No formula yet"
              end
            end
            
          end

          session_data = controller.view_context.session
          tmp_params = session_data[:tmp_params] || {}
          item_key = f.object.id.to_s
          tmp_data = tmp_params[item_key]&.deep_symbolize_keys || {}

          tmp_fixed = tmp_data[:fixed] || {}
          tmp_open = tmp_data[:open] || []
          tmp_select = tmp_data[:select] || {}

          panel "Parameters" do
            render partial: "admin/items/parameters", locals: {
              fixed_parameters: tmp_fixed,
              open_parameters_label: tmp_open,
              select_parameters: tmp_select,
              item: f.object,
              mode: :edit
            }
          end
        end
      else
        panel "After creating or updating this item, you will be redirected to edit page where you can add parameters."
      end
    end
    f.actions
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

    if item.fixed?
      panel "Price" do
        para "Price: #{item.item_pricing&.default_fixed_price}"
      end
    elsif item.open?
      pricing = item.item_pricing
      if pricing&.open_parameters_label&.first.present?
        panel "Open Parameter" do
          div class: "calculation-formula-box" do
            pricing.open_parameters_label.first
          end
        end              end    
    elsif item.fixed_open?
      pricing = item.item_pricing
      if pricing&.calculation_formula.present?
        panel "Calculation Formula" do
          div class: "calculation-formula-box" do
            pricing.calculation_formula
          end
        end
      end
      panel "Pricing Parameters" do
        render partial: "admin/items/parameters", locals: {
          fixed_parameters: pricing&.fixed_parameters || {},
          open_parameters_label: pricing&.open_parameters_label || [],
          select_parameters: pricing&.pricing_options || {},
          item: item,
          mode: :show
        }
      end
    end
  end

  controller do
    before_action :init_session_from_db, only: :edit

    def init_session_from_db
      @item = Item.find(params[:id])
      return unless @item.fixed_open?
      item_key = @item.id.to_s
      session[:tmp_params] ||= {}
      initialize_tmp_params(item_key)
    end

    def initialize_tmp_params(item_key)
      return if session[:tmp_params].key?(item_key)
      pricing = @item.item_pricing
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

    def create
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
      @item = Item.find(params[:id])
      old_pricing_type = @item.pricing_type
      item_key = @item.id.to_s
      new_pricing_type = permitted_params[:item][:pricing_type]
      session[:tmp_params]&.delete(item_key) if new_pricing_type != "fixed_open"
      session_data = new_pricing_type == "fixed_open" ? session[:tmp_params][item_key] : nil
      updater = ItemUpdater.new(@item, permitted_params[:item], session_data)
    
      if updater.call
        if old_pricing_type != "fixed_open" && @item.pricing_type == "fixed_open"
          redirect_to edit_admin_item_path(@item), notice: "Item updated! Now you can add parameters."
        else
          redirect_to admin_item_path(@item), notice: "Item updated!"
        end
      else
        flash[:error] = "Failed to update item"
        render :edit
      end
    end
  end

  actions :all, except: :destroy

  action_item :back, only: :show do
    link_to "Back", admin_items_path
  end

  action_item :toggle, only: :show do
    link_to(resource.is_disabled? ? "Enable item" : "Disable item", toggle_admin_item_path(resource),
            method: :put,
            data: { confirm: "Are you sure?" })
  end

  member_action :toggle, method: :put do
    resource.update(is_disabled: !resource.is_disabled)
    redirect_to admin_items_path, notice: "Item has been #{resource.is_disabled? ? 'disabled' : 'enabled'}."
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
    end
    flash[:notice] = "Parameter removed."
    redirect_to edit_admin_item_path(@item)
  end

  member_action :new_parameter, method: :get do
    @item = Item.find(params[:id])
  end

  member_action :create_parameter, method: :post do
    @item = Item.find(params[:id])
    item_key = @item.id.to_s
    
    session[:tmp_params] ||= {}
    session[:tmp_params][item_key] ||= { fixed: {}, open: [], select: {} }
    store = session[:tmp_params][item_key]
    store = store.deep_symbolize_keys
    session[:tmp_params][item_key] = store
    
    case params[:parameter_type]
    when "Fixed"
      param_name = params[:fixed_parameter_name].to_s.strip
      param_value = params[:fixed_parameter_value]
      store[:fixed][param_name] = param_value if param_name.present?
      (store[:formula_parameters] ||= []) << param_name unless param_name.blank?
      
    when "Open"
      param_name = params[:open_parameter_name].to_s.strip
      store[:open] << param_name if param_name.present?
      (store[:formula_parameters] ||= []) << param_name unless param_name.blank?
      
    when "Select"
      param_name = params[:select_parameter_name].to_s.strip
      sub_hash = {}
      
      (1..10).each do |i|
        desc = params["option_description_#{i}"]
        val = params["option_value_#{i}"]
        next if desc.blank? || val.blank?
        sub_hash[desc] = val
      end
      
      store[:select][param_name] = sub_hash if param_name.present?
      (store[:formula_parameters] ||= []) << param_name unless param_name.blank?
    end
    
    flash[:notice] = "Parameter '#{params[:parameter_type]}' added (stored in session, not saved yet)."
    redirect_to edit_admin_item_path(@item)
  end

  member_action :new_formula, method: :get do
    @item = Item.find(params[:id])
    item_key = @item.id.to_s
    session[:tmp_params] ||= {}
  
    store = session[:tmp_params][item_key] || {}
    @formula_params = store["formula_parameters"] || []
    @initial_formula = @item.item_pricing&.calculation_formula
  end
  
  member_action :update_formula, method: :post do
    @item = Item.find(params[:id])
    pricing = @item.item_pricing || @item.build_item_pricing
    pricing.calculation_formula = params[:calculation_formula]
    if pricing.save
      flash[:notice] = "Formula saved!"
    else
      flash[:error] = "Failed to save formula."
    end
    redirect_to edit_admin_item_path(@item)
  end
end
