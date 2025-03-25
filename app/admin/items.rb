ActiveAdmin.register Item do
  permit_params :name, :description, :pricing_type, :category_id, :is_disabled,
                item_pricings_attributes: [:id, :default_fixed_price, :fixed_parameters, :is_selectable_options,
                                          :pricing_options, :open_parameters_label, :open_parameters_label, :open_parameters_label_as_string, :formula_parameters,
                                          :calculation_formula, :is_open, :_destroy]


  filter :name_cont, as: :string, label: "Product Name"
  filter :category, as: :select, collection: -> { Category.pluck(:name, :id) }, label: "Category"
  filter :pricing_type, as: :select, collection: Item.pricing_types, label: "Pricing Type"
  filter :is_disabled, label: "Disabled"

  index do
    selectable_column
    id_column
    column :name
    column :pricing_type
    column "Category", sortable: :category_id do |item|
      link_to item.category.name, admin_category_path(item.category) if item.category
    end
    column("Disabled") {|item| status_tag item.is_disabled, label: item.is_disabled? ? "True" : "False" }
    column :created_at
    column :updated_at
    actions defaults: false do |item|
      links = []
      links << link_to("View", admin_item_path(item), class: "member_link")
      links << link_to("Edit", edit_admin_item_path(item), class: "member_link")
      links << link_to(item.is_disabled? ? "Enable" : "Disable", toggle_admin_item_path(item), method: :put,
                                                                                               data: { confirm: "Are you sure?" }, class: "member_link")
      safe_join(links)
    end
  end

  before_action only: :show do
    active_admin_config.action_items.delete_if do |item|
      item.name == :destroy
    end
  end

  form do |f|
    f.semantic_errors
  
    f.inputs "Item Details" do
      f.input :name, required: true
      f.input :description
      f.input :category_id, as: :select,
                             collection: Category.pluck(:name, :id), 
                             include_blank: "No Category"
  
      f.input :pricing_type, as: :radio
    end
  
    pricing = if f.object.fixed_open? && !f.object.persisted?
      nil
    else
      f.object.item_pricings.first_or_initialize
    end

  
    case f.object.pricing_type
    when "fixed"
      f.inputs "Pricing parameter" do
        f.fields_for :item_pricings, pricing do |pf|
          pf.input :default_fixed_price, label: "Fixed Price"
        end
      end
  
    when "open"
      f.inputs "Pricing parameter" do
        f.fields_for :item_pricings, pricing do |pf|
          pf.input :open_parameters_label_as_string,
                   as: :text,
                   label: "Parameters name",
                   input_html: {
                     rows: 1,
                     value: pf.object.open_parameters_label_as_string
                   }
        end
      end
  
    when "fixed_open"
      if f.object.persisted?
      f.inputs "Fixed + Open Pricing" do
        f.fields_for :item_pricings, pricing do |pf|
        pf.input :formula_parameters, as: :text, label: "Formula Parameters (JSON)"
        pf.input :calculation_formula, label: "Calculation Formula"
      end
    end 
      else 
        panel "After creating this item, you will be redirected to edit page where you can add parameters."
      end
    end
    f.actions
  end

  controller do
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
  end

  action_item :add_parameter, only: :edit do
    if resource.fixed_open?
      link_to "Add Parameter", new_parameter_admin_item_path(resource)
    end
  end

  member_action :new_parameter, method: :get do
    @item = Item.find(params[:id])
    # Здесь можно отрендерить «кастомную» форму (Arbre / partial),
    # где пользователь выбирает тип параметра (Fixed/Open/Select) и заполняет поля.
    # Например, render "admin/items/new_parameter" -- если сделаем partial.
  end
  
  member_action :create_parameter, method: :post do
    @item = Item.find(params[:id])
    @item_pricing = @item.item_pricings.first_or_create
  
    param_type = params[:parameter_type]  # "Fixed"/"Open"/"Select"
  
    case param_type
    when "Fixed"
      new_hash = @item_pricing.fixed_parameters || {}
      new_hash[params[:fixed_parameter_name]] = params[:fixed_parameter_value]
      @item_pricing.fixed_parameters = new_hash
  
      @item_pricing.is_open = false
      @item_pricing.is_selectable_options = false
  
    when "Open"
      arr = @item_pricing.open_parameters_label || []
      arr << params[:open_parameter_name].to_s
      @item_pricing.open_parameters_label = arr
  
      @item_pricing.is_open = true
      @item_pricing.is_selectable_options = false
  
    when "Select"
      sel = @item_pricing.pricing_options || {}
      sub_hash = {}
      (1..10).each do |i|
        desc = params["option_description_#{i}"]
        val  = params["option_value_#{i}"]
        next if desc.blank? || val.blank?
  
        sub_hash[desc] = val
      end
      sel[params[:select_parameter_name]] = sub_hash
      @item_pricing.pricing_options = sel
  
      @item_pricing.is_open = false
      @item_pricing.is_selectable_options = true
    end

    if @item_pricing.save
      redirect_to edit_admin_item_path(@item), notice: "Parameter added!"
    else
      flash[:error] = "Parameter not saved: #{@item_pricing.errors.full_messages.join(', ')}"
      redirect_to new_parameter_admin_item_path(@item)
    end
  end
  

  action_item :back, only: :show do
    link_to "Back", admin_items_path
  end

  member_action :toggle, method: :put do
    resource.update(is_disabled: !resource.is_disabled)
    redirect_to admin_items_path, notice: "Item has been #{resource.is_disabled? ? 'disabled' : 'enabled'}."
  end

  action_item :toggle, only: :show do
    link_to(resource.is_disabled? ? "Enable item" : "Disable item", toggle_admin_item_path(resource), method: :put,
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