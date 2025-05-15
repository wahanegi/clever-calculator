ActiveAdmin.register Item do
  permit_params do
    %i[
      name description category_id is_disabled is_fixed is_open is_selectable_options
      fixed_parameters pricing_options open_parameters_label formula_parameters calculation_formula
    ]
  end

  filter :name_cont, as: :string, label: "Product Name"
  filter :category, as: :select, collection: -> { Category.pluck(:name, :id) }
  filter :is_disabled, label: "Disabled"

  index do
    selectable_column
    id_column
    column :name
    column :category, sortable: :category_id
    column("Enabled") { |item| status_tag !item.is_disabled, label: item.is_disabled? ? "False" : "True" }
    column :created_at
    column :updated_at
    actions defaults: false do |resource|
      item("View", admin_item_path(resource), class: "member_link")
      item("Edit", edit_admin_item_path(resource), class: "member_link")

      unless resource.category&.is_disabled?
        item(resource.is_disabled? ? "Enable" : "Disable", toggle_admin_item_path(resource),
             method: :put,
             data: { confirm: "Are you sure?" },
             class: "member_link")
      end
    end
  end

  form do |f|
    f.semantic_errors

    div id: "add-parameter-button-wrapper", style: "margin-top: 20px;" do
    end

    item_key = f.object.persisted? ? f.object.id.to_s : "new"
    session_service = TmpParamsSessionService.new(controller.view_context.session, item_key)
    meta_data = session_service.all

    f.inputs "Item Details" do
      f.input :name, required: true, input_html: { value: f.object.name.presence || meta_data["name"] }, hint: "Maximum 50 characters"
      f.input :description, as: :string, input_html: { value: f.object.description.presence || meta_data["description"] }
      f.input :category_id, as: :select,
                            collection: Category.pluck(:name, :id),
                            include_blank: "No Category",
                            selected: f.object.category_id.presence || meta_data["category_id"] || params[:category_id]
    end

    div class: "add-param-link-wrapper" do
      item_id = f.object.persisted? ? f.object.id.to_s : "new"
      formula_label = f.object.calculation_formula.present? ? "Update Calculation Formula" : "Create Calculation Formula"

      para do
        concat(link_to("Add Parameter", "#", class: "button store-and-navigate", data: {
                         redirect: new_parameter_admin_item_path(id: item_id),
                         item_id: item_id
                       }))

        concat(link_to(formula_label, "#", class: "button store-and-navigate", data: {
                         redirect: new_formula_admin_item_path(id: item_id),
                         item_id: item_id
                       }))
      end
    end

    f.inputs "Calculation Formula" do
      f.input :formula_parameters, as: :hidden
      div class: "formula-preview" do
        div class: "formula-preview" do
          span class: "formula-label" do
            "Calculation Formula:"
          end

          span class: "formula" do
            formula = session_service.get(:calculation_formula) || f.object.calculation_formula
            formula.presence || "No formula yet"
          end
        end
      end

      tmp_fixed = session_service.get(:fixed) || {}
      tmp_open = session_service.get(:open) || []
      tmp_select = session_service.get(:select) || {}

      panel "Pricing Parameters" do
        render partial: "admin/items/parameters", locals: {
          fixed_parameters: tmp_fixed,
          open_parameters_label: tmp_open,
          select_parameters: tmp_select,
          item: f.object,
          mode: :edit
        }
      end
    end

    f.actions do
      f.action :submit
      f.action :cancel, label: "Cancel", button_html: {
        class: "custom-cancel-button",
        id: "custom-cancel-button",
        data: { item_id: item_key }
      }
    end
  end

  show do
    attributes_table do
      row :id
      row :name
      row "Description" do |item|
        item.description.presence || "No description"
      end
      row :category
      row "Status" do |item|
        status_tag(item.is_disabled? ? "Disable" : "Enable", class: item.is_disabled? ? "red" : "green")
      end
      row :created_at
      row :updated_at
    end

    if item.calculation_formula.present?
      panel "Calculation Formula" do
        div class: "calculation-formula-box" do
          item.calculation_formula
        end
      end
    end

    panel "Pricing Parameters" do
      render partial: "admin/items/parameters", locals: {
        fixed_parameters: item.fixed_parameters || {},
        open_parameters_label: item&.open_parameters_label || [],
        select_parameters: item.pricing_options || {},
        item: item,
        mode: :show
      }
    end
  end

  batch_action :assign_to_category, form: -> { { category: Category.pluck(:name, :id) } } do |ids, inputs|
    category = Category.find_by(id: inputs[:category])

    if category
      # rubocop:disable Rails/SkipsModelValidations
      Item.where(id: ids).update_all(category_id: category.id)
      # rubocop:enable Rails/SkipsModelValidations
      redirect_to admin_items_path, notice: "Category was successfully assigned."
    else
      redirect_back fallback_location: admin_items_path, alert: "Category not found."
    end
  end

  controller do
    helper ActiveAdmin::ItemsHelper
    helper_method :session_service

    def create
      @item = Item.new(permitted_params[:item])
      session_service.update_with_tmp_to_item(@item)

      if @item.save
        session_service.delete

        redirect_to admin_item_path(@item), notice: "Item was successfully created."
      else
        flash.now[:error] = "Failed to create item: #{@item.errors.full_messages.to_sentence}"
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @item = Item.find(params[:id])
      if session_service.all.blank?
        session_service.set(:fixed, @item.fixed_parameters || {})
        session_service.set(:open, @item.open_parameters_label || [])
        session_service.set(:select, @item.pricing_options || {})
        session_service.set(:formula_parameters, @item.formula_parameters || [])
        session_service.set(:calculation_formula, @item.calculation_formula)
      end

      super
    end

    def update
      @item = Item.find(params[:id])
      session_service.update_with_tmp_to_item(@item)

      # If form submission has a blank formula_parameters, restore from session or model
      if permitted_params[:item][:formula_parameters].blank?
        fallback_formula_params = session_service.get(:formula_parameters) || @item.formula_parameters
        @item.formula_parameters = fallback_formula_params
      end

      if @item.update(permitted_params[:item].except(:formula_parameters))
        session_service.delete

        if @item.category.present?
          redirect_to edit_admin_category_path(@item.category), notice: "Item was successfully updated."
        else
          redirect_to admin_item_path(@item), notice: "Item was successfully updated."
        end
      else
        flash[:error] = "Failed to update item: #{@item.errors.full_messages.to_sentence}"
        render :edit
      end
    end

    private

    def session_service
      @session_service ||= begin
        item_key = params[:id].presence || "new"
        TmpParamsSessionService.new(session, item_key.to_s)
      end
    end
  end

  actions :all, except: [:destroy]

  action_item :toggle, only: :show do
    unless resource.category&.is_disabled?
      link_to(
        resource.is_disabled? ? "Enable item" : "Disable item",
        toggle_admin_item_path(resource),
        method: :put,
        data: { confirm: "Are you sure?" }
      )
    end
  end

  action_item :back, only: :show do
    if resource.category.present?
      link_to "Back to Category", admin_category_path(resource.category)
    else
      link_to "Back to Items", admin_items_path
    end
  end

  member_action :toggle, method: :put do
    resource.update(is_disabled: !resource.is_disabled)
    redirect_to admin_items_path, notice: "Item has been #{resource.is_disabled? ? 'disabled' : 'enabled'}."
  end

  member_action :new_parameter, method: :get do
    @item = params[:id] == "new" ? Item.new : Item.find(params[:id])
  end

  member_action :create_parameter, method: :post do
    @item = Item.find_by(id: params[:id]) || Item.new

    param_type = params[:parameter_type]
    param_name = case param_type
                 when "Fixed" then params[:fixed_parameter_name].to_s.strip
                 when "Open" then params[:open_parameter_name].to_s.strip
                 when "Select" then params[:select_parameter_name].to_s.strip
                 end
    param_name = param_name.gsub(/\s+/, "_")
    if param_name.blank?
      flash[:error] = "Parameter name can't be blank"
      return redirect_back(fallback_location: @item&.id ? edit_admin_item_path(@item) : new_admin_item_path)
    end

    session_service.add_formula_parameter(param_name)

    case param_type
    when "Fixed"
      param_value = params[:fixed_parameter_value].to_s.strip
      # Validate parameter value
      if param_value.blank?
        flash[:error] = "Parameter value can't be blank for Fixed parameter"
        return redirect_back(fallback_location: @item&.id ? edit_admin_item_path(@item) : new_admin_item_path)
      end
      fixed = session_service.get(:fixed) || {}
      fixed[param_name] = param_value
      session_service.set(:fixed, fixed)

    when "Open"
      open_params = session_service.get(:open) || []
      open_params << param_name unless open_params.include?(param_name)
      session_service.set(:open, open_params)

    when "Select"
      value_label = params[:value_label].to_s.strip
      if value_label.blank?
        flash[:error] = "Value Label is required for Select parameter"
        return redirect_back(fallback_location: @item&.id ? edit_admin_item_path(@item) : new_admin_item_path)
      end

      sub_hash = {}
      valid_options = false
      (params[:select_options] || []).each do |pair|
        desc = pair["description"].to_s.strip
        val = pair["value"].to_s.strip
        next if desc.blank? || val.blank?

        sub_hash[desc] = val
        valid_options = true
      end
      # Validate parameter value
      unless valid_options
        flash[:error] = "At least one valid option (with non-empty description and value) is required for Select parameter"
        return redirect_back(fallback_location: @item&.id ? edit_admin_item_path(@item) : new_admin_item_path)
      end

      select = session_service.get(:select) || {}
      select[param_name] = {
        "options" => sub_hash,
        "value_label" => value_label
      }
      session_service.set(:select, select)

    else
      flash[:error] = "Unknown parameter type"
      return redirect_back(fallback_location: @item&.id ? edit_admin_item_path(@item) : new_admin_item_path)
    end

    flash[:notice] = "Parameter '#{param_name}' added (stored in session)."
    redirect_to @item.persisted? ? edit_admin_item_path(@item) : new_resource_path
  end

  member_action :remove_parameter, method: :delete do
    @item = params[:id] == "new" ? Item.new : Item.find(params[:id])

    param_type = params[:param_type].to_s
    key = params[:param_key].to_s
    desc_key = params[:desc_key].to_s if params[:desc_key].present?

    case param_type
    when "fixed"
      fixed = session_service.get(:fixed) || {}
      fixed.delete(key.to_sym)
      session_service.set(:fixed, fixed)
      session_service.remove_formula_parameter(key)

    when "open"
      open = session_service.get(:open) || []
      open.delete(key)
      session_service.set(:open, open)
      session_service.remove_formula_parameter(key)

    when "select"
      select = session_service.get(:select) || {}

      if desc_key.present?
        select[key]&.delete(desc_key)
        select.delete(key) if select[key] && select[key].empty?
      else
        select = select.reject { |k, _| k.to_s == key }
      end

      session_service.set(:select, select)
      session_service.remove_formula_parameter(key)
    end
    redirect_to @item.persisted? ? edit_admin_item_path(@item) : new_resource_path
  end

  member_action :save_meta_to_session, method: :post do
    session_service.store_meta(
      name: params[:name],
      description: params[:description],
      category_id: params[:category_id]
    )

    head :ok
  end

  member_action :new_formula, method: :get do
    @item = params[:id] == "new" ? Item.new : Item.find(params[:id])

    @formula_params = session_service.get(:formula_parameters) || []
    @initial_formula = session_service.get(:calculation_formula) || @item.calculation_formula
  end

  member_action :update_formula, method: :post do
    session_service.set(:calculation_formula, params[:calculation_formula])

    if params[:id] != "new"
      @item = Item.find(params[:id])
      @item.calculation_formula = params[:calculation_formula]
    end

    flash[:notice] = "Formula saved (in session)!"
    redirect_to params[:id] == "new" ? new_resource_path : edit_admin_item_path(params[:id])
  end

  member_action :clear_session, method: :post do
    session_service.delete

    head :ok
  end
end
