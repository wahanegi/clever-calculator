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
    id_column
    column :name
    column :category, sortable: :category_id
    column("Disabled") { |item| status_tag item.is_disabled, label: item.is_disabled? ? "True" : "False" }
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
      f.input :name, required: true, input_html: { value: f.object.name.presence || meta_data["name"] }
      f.input :description, as: :string, input_html: { value: f.object.description.presence || meta_data["description"] }
      f.input :category_id, as: :select,
                            collection: Category.pluck(:name, :id),
                            include_blank: "No Category",
                            selected: f.object.category_id.presence || meta_data["category_id"]
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

      tmp_fixed  = session_service.get(:fixed) || {}
      tmp_open   = session_service.get(:open) || []
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

  controller do
    def create
      @item = Item.new(permitted_params[:item])
      item_key = "new"
      service = TmpParamsSessionService.new(session, item_key)

      service.update_with_tmp_to_item(@item)

      if @item.save
        service.delete
        redirect_to admin_item_path(@item), notice: "Item was successfully created."
      else
        flash.now[:error] = "Failed to create item: #{@item.errors.full_messages.to_sentence}"
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @item = Item.find(params[:id])
      item_key = @item.id.to_s
      service = TmpParamsSessionService.new(session, item_key)

      if service.all.blank?
        service.set(:fixed, @item.fixed_parameters || {})
        service.set(:open, @item.open_parameters_label || [])
        service.set(:select, @item.pricing_options || {})
        service.set(:formula_parameters, @item.formula_parameters || [])
        service.set(:calculation_formula, @item.calculation_formula)
      end

      super
    end

    def update
      @item = Item.find(params[:id])
      item_key = @item.id.to_s
      service = TmpParamsSessionService.new(session, item_key)

      service.update_with_tmp_to_item(@item)

      if @item.update(permitted_params[:item])
        service.delete
        redirect_to admin_item_path(@item), notice: "Item was successfully updated."
      else
        service.update_with_tmp_to_item(@item)
        flash[:error] = "Failed to update item: #{@item.errors.full_messages.to_sentence}"
        render :edit
      end
    end
  end

  actions :all, except: [:destroy]

  action_item :back, only: :show do
    link_to "Back to Items", admin_items_path
  end

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

  member_action :toggle, method: :put do
    resource.update(is_disabled: !resource.is_disabled)
    redirect_to admin_items_path, notice: "Item has been #{resource.is_disabled? ? 'disabled' : 'enabled'}."
  end

  member_action :new_parameter, method: :get do
    @item = params[:id] == "new" ? Item.new : Item.find(params[:id])
  end

  member_action :create_parameter, method: :post do
    @item = Item.find_by(id: params[:id]) || Item.new
    item_key = @item.persisted? ? @item.id.to_s : "new"
    service = TmpParamsSessionService.new(session, item_key)

    param_type = params[:parameter_type]
    param_name = case param_type
                 when "Fixed"  then params[:fixed_parameter_name].to_s.strip
                 when "Open"   then params[:open_parameter_name].to_s.strip
                 when "Select" then params[:select_parameter_name].to_s.strip
                 end

    if param_name.blank?
      flash[:error] = "Parameter name can't be blank"
      return redirect_back(fallback_location: @item&.id ? edit_admin_item_path(@item) : new_admin_item_path)
    end

    service.add_formula_parameter(param_name)

    case param_type
    when "Fixed"
      param_value = params[:fixed_parameter_value]
      fixed = service.get(:fixed) || {}
      fixed[param_name] = param_value
      service.set(:fixed, fixed)

    when "Open"
      open_params = service.get(:open) || []
      open_params << param_name unless open_params.include?(param_name)
      service.set(:open, open_params)

    when "Select"
      sub_hash = {}
      (params[:select_options] || []).each do |pair|
        desc = pair["description"]
        val  = pair["value"]
        next if desc.blank? || val.blank?

        sub_hash[desc] = val
      end

      value_label = params[:value_label]
      if value_label.blank?
        flash[:error] = "Value Label is required for Select parameter"
        return redirect_back(fallback_location: @item&.id ? edit_admin_item_path(@item) : new_admin_item_path)
      end

      select = service.get(:select) || {}
      select[param_name] = {
        "options" => sub_hash,
        "value_label" => value_label
      }
      service.set(:select, select)

    else
      flash[:error] = "Unknown parameter type"
      return redirect_back(fallback_location: @item&.id ? edit_admin_item_path(@item) : new_admin_item_path)
    end

    flash[:notice] = "Parameter '#{param_name}' added (stored in session)."
    redirect_to @item.persisted? ? edit_admin_item_path(@item) : new_resource_path
  end

  member_action :remove_parameter, method: :delete do
    @item = params[:id] == "new" ? Item.new : Item.find(params[:id])
    item_key = @item.persisted? ? @item.id.to_s : "new"
    service = TmpParamsSessionService.new(session, item_key)

    param_type = params[:param_type].to_s
    key = params[:param_key].to_s
    desc_key = params[:desc_key].to_s if params[:desc_key].present?

    case param_type
    when "fixed"
      fixed = service.get(:fixed) || {}
      fixed.delete(key.to_sym)
      service.set(:fixed, fixed)
      service.remove_formula_parameter(key)

    when "open"
      open = service.get(:open) || []
      open.delete(key)
      service.set(:open, open)
      service.remove_formula_parameter(key)

    when "select"
      select = service.get(:select) || {}

      if desc_key.present?
        select[key]&.delete(desc_key)
        select.delete(key) if select[key] && select[key].empty?
      else
        select = select.reject { |k, _| k.to_s == key }
      end

      service.set(:select, select)
      service.remove_formula_parameter(key)
    end
    redirect_to @item.persisted? ? edit_admin_item_path(@item) : new_resource_path
  end

  member_action :save_meta_to_session, method: :post do
    item_key = params[:id] == "new" ? "new" : params[:id].to_s
    service = TmpParamsSessionService.new(session, item_key)

    service.store_meta(
      name: params[:name],
      description: params[:description],
      category_id: params[:category_id]
    )

    head :ok
  end

  member_action :new_formula, method: :get do
    @item = params[:id] == "new" ? Item.new : Item.find(params[:id])
    item_key = @item.persisted? ? @item.id.to_s : "new"
    service = TmpParamsSessionService.new(session, item_key)

    @formula_params = service.get(:formula_parameters) || []
    @initial_formula = service.get(:calculation_formula) || @item.calculation_formula
  end

  member_action :update_formula, method: :post do
    item_key = params[:id] == "new" ? "new" : params[:id].to_s
    service = TmpParamsSessionService.new(session, item_key)

    service.set(:calculation_formula, params[:calculation_formula])

    if params[:id] != "new"
      @item = Item.find(params[:id])
      @item.calculation_formula = params[:calculation_formula]
    end

    flash[:notice] = "Formula saved (in session)!"
    redirect_to params[:id] == "new" ? new_resource_path : edit_admin_item_path(params[:id])
  end

  member_action :clear_session, method: :post do
    item_key = params[:id].to_s
    service = TmpParamsSessionService.new(session, item_key)

    service.delete

    head :ok
  end
end
