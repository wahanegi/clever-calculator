ActiveAdmin.register Item do
  permit_params do
    %i[
      name description category_id is_disabled is_fixed is_open is_selectable_options
      fixed_parameters pricing_options open_parameters_label formula_parameters calculation_formula
    ]
  end

  filter :name_cont, as: :string, label: "Product Name"
  filter :category, as: :select, collection: -> { Category.pluck(:name, :id) }, label: "Category"
  filter :is_disabled, label: "Disabled"

  index do
    id_column
    column :name
    column "Category", sortable: :category_id do |item|
      link_to item.category.name, admin_category_path(item.category) if item.category
    end
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
    session_data = controller.view_context.session
    tmp_params = session_data[:tmp_params] || {}
    meta_data = tmp_params[item_key] || {}

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
            item_key = f.object.persisted? ? f.object.id.to_s : "new"
            session_formula = controller.view_context.session.dig(:tmp_params, item_key, "calculation_formula")
            session_formula.presence || f.object.calculation_formula.presence || "No formula yet"
          end
        end
      end

      item_key = f.object.persisted? ? f.object.id.to_s : "new"
      session_data = controller.view_context.session
      tmp_params = session_data[:tmp_params] || {}
      tmp_data = tmp_params[item_key]&.deep_symbolize_keys || {}

      tmp_fixed = tmp_data[:fixed] || {}
      tmp_open = tmp_data[:open] || []
      tmp_select = tmp_data[:select] || {}

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
      row "Category" do |item|
        link_to item.category.name, admin_category_path(item.category) if item.category
      end
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

      apply_tmp_params(@item, session[:tmp_params][item_key]) if session[:tmp_params]&.key?(item_key)

      if @item.save
        session[:tmp_params]&.delete(item_key)
        redirect_to admin_item_path(@item), notice: "Item was successfully created."
      else
        flash.now[:error] = "Failed to create item: #{@item.errors.full_messages.to_sentence}"
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @item = Item.find(params[:id])
      item_key = @item.id.to_s

      session[:tmp_params] ||= {}
      session[:tmp_params][item_key] ||= {
        fixed: @item.fixed_parameters || {},
        open: @item.open_parameters_label || [],
        select: @item.pricing_options || {},
        formula_parameters: @item.formula_parameters || [],
        calculation_formula: @item.calculation_formula
      }

      super
    end

    def update
      @item = Item.find(params[:id])
      item_key = @item.id.to_s

      apply_tmp_params(@item, session[:tmp_params][item_key]) if session[:tmp_params]&.key?(item_key)

      if @item.update(permitted_params[:item])
        session[:tmp_params]&.delete(item_key)
        redirect_to admin_item_path(@item), notice: "Item was successfully updated."
      else
        apply_tmp_params(@item, session[:tmp_params][item_key]) if session[:tmp_params]&.key?(item_key)
        flash[:error] = "Failed to update item: #{@item.errors.full_messages.to_sentence}"
        render :edit
      end
    end

    private

    def apply_tmp_params(item, tmp)
      return if tmp.blank?

      data = tmp.deep_symbolize_keys
      item.fixed_parameters       = data[:fixed] || {}
      item.open_parameters_label  = data[:open] || []
      item.pricing_options        = data[:select] || {}
      item.formula_parameters     = data[:formula_parameters] || []
      Rails.logger.info "🧮 TMP calculation_formula = #{data[:calculation_formula]}"
      item.calculation_formula    = data[:calculation_formula] || nil

      item.is_open                = item.open_parameters_label.any?
      item.is_selectable_options  = item.pricing_options.any?
      item.is_fixed               = item.fixed_parameters.any?

      Rails.logger.info "🧠 APPLY TMP: formula_parameters = #{item.formula_parameters.inspect}"
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

    session[:tmp_params] ||= {}
    session[:tmp_params][item_key] ||= {}

    Rails.logger.info "🔑 item_key: #{item_key}"
    Rails.logger.info "📦 Session before: #{session[:tmp_params][item_key]}"

    store = session[:tmp_params][item_key].deep_symbolize_keys
    store[:fixed] ||= {}
    store[:open] ||= []
    store[:select] ||= {}
    store[:formula_parameters] ||= []

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

    store[:formula_parameters] << param_name unless store[:formula_parameters].include?(param_name)

    case param_type
    when "Fixed"
      param_value = params[:fixed_parameter_value]
      store[:fixed][param_name] = param_value

    when "Open"
      store[:open] << param_name unless store[:open].include?(param_name)

    when "Select"
      sub_hash = {}

      select_options = params[:select_options] || []

      select_options.each do |pair|
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

      store[:select][param_name] = {
        "options" => sub_hash,
        "value_label" => value_label
      }

    else
      flash[:error] = "Unknown parameter type"
      return redirect_back(fallback_location: @item&.id ? edit_admin_item_path(@item) : new_admin_item_path)
    end

    session[:tmp_params][item_key] = store.deep_stringify_keys

    Rails.logger.info "📤 Session after update: #{session[:tmp_params][item_key]}"

    flash[:notice] = "Parameter '#{param_name}' added (stored in session)."
    Rails.logger.info "🧠 Final saved SELECT: #{store[:select][param_name].inspect}"
    Rails.logger.info "📤 Full session after update: #{session[:tmp_params].inspect}"

    redirect_to @item.persisted? ? edit_admin_item_path(@item) : new_resource_path
  end

  member_action :remove_parameter, method: :delete do
    Rails.logger.info "🧩 REMOVE PARAMETER"
    @item = params[:id] == "new" ? Item.new : Item.find(params[:id])
    item_key = @item.persisted? ? @item.id.to_s : "new"
    Rails.logger.info "🔑 item_key: #{item_key}"

    session[:tmp_params] ||= {}
    session[:tmp_params][item_key] ||= {
      fixed: {},
      open: [],
      select: {},
      formula_parameters: []
    }

    store = session[:tmp_params][item_key].deep_symbolize_keys
    param_type = params[:param_type].to_s
    key = params[:param_key].to_s
    desc_key = params[:desc_key].to_s if params[:desc_key].present?

    Rails.logger.info "📦 Session before delete: #{store}"
    Rails.logger.info "🛠 Param type: #{param_type}, Key: #{key}, Desc key: #{desc_key}"

    case param_type
    when "fixed"
      store[:fixed]&.delete(key.to_sym)
      store[:formula_parameters]&.delete(key)
      Rails.logger.info "🗑 Deleted fixed #{key}"

    when "open"
      store[:open]&.delete(key)
      store[:formula_parameters]&.delete(key)
      Rails.logger.info "🗑 Deleted open #{key}"

    when "select"
      key_str = key.to_s
      if desc_key.present?
        store[:select][key_str]&.delete(desc_key)
        store[:select].delete(key_str) if store[:select][key_str] && store[:select][key_str].empty?
        Rails.logger.info "🗑 Deleted desc #{desc_key} from #{key_str}"
      else
        store[:select] = store[:select].reject { |k, _| k.to_s == key_str }
        Rails.logger.info "🗑 Deleted whole select #{key_str}"
      end
      store[:formula_parameters]&.delete(key_str)

    else
      Rails.logger.warn "⚠️ Unknown param_type=#{param_type}"
    end

    session[:tmp_params][item_key] = store.deep_stringify_keys

    Rails.logger.info "📦 Session after delete: #{session[:tmp_params][item_key]}"
    redirect_to @item.persisted? ? edit_admin_item_path(@item) : new_resource_path
  end

  member_action :save_meta_to_session, method: :post do
    item_key = params[:id] == "new" ? "new" : params[:id].to_s

    session[:tmp_params] ||= {}
    session[:tmp_params][item_key] ||= {}
    session[:tmp_params][item_key]["name"] = params[:name]
    session[:tmp_params][item_key]["description"] = params[:description]
    session[:tmp_params][item_key]["category_id"] = params[:category_id]

    Rails.logger.info "💾 Saved to session: #{session[:tmp_params][item_key].slice('name', 'description', 'category_id')}"

    head :ok
  end

  member_action :new_formula, method: :get do
    @item = params[:id] == "new" ? Item.new : Item.find(params[:id])
    item_key = @item.persisted? ? @item.id.to_s : "new"

    session[:tmp_params] ||= {}
    store = session[:tmp_params][item_key] || {}

    @formula_params = store["formula_parameters"] || []
    @initial_formula = store["calculation_formula"] || @item.calculation_formula
  end

  member_action :update_formula, method: :post do
    if params[:id] == "new"
      session[:tmp_params] ||= {}
      session[:tmp_params]["new"] ||= {}
      session[:tmp_params]["new"]["calculation_formula"] = params[:calculation_formula]
    else
      @item = Item.find(params[:id])

      session[:tmp_params] ||= {}
      session[:tmp_params][@item.id.to_s] ||= {}
      session[:tmp_params][@item.id.to_s]["calculation_formula"] = params[:calculation_formula]

      @item.calculation_formula = params[:calculation_formula]
    end

    flash[:notice] = "Formula saved (in session)!"
    redirect_to params[:id] == "new" ? new_resource_path : edit_admin_item_path(params[:id])
  end

  member_action :clear_session, method: :post do
    item_key = params[:id].to_s
    if session[:tmp_params].present?
      Rails.logger.info "⚠️ TRYING TO DELETE session[:tmp_params][#{item_key}]"
      Rails.logger.info "🔍 BEFORE DELETE: #{session[:tmp_params][item_key].inspect}"

      session[:tmp_params].delete(item_key)

      Rails.logger.info "🧹 DELETED! AFTER: #{session[:tmp_params].inspect}"
    else
      Rails.logger.warn "⚠️ tmp_params session is empty, nothing to delete"
    end

    head :ok
  end
end
