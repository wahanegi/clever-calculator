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
                             collection: Category.pluck(:name, :id).push(["No Category", nil]),
                             include_blank: false
  
      f.input :pricing_type, as: :select, prompt: "Select Pricing Type",
                             input_html: { onchange: 'this.form.submit();' }
    end
  
    pricing = f.object.item_pricings.first_or_initialize
  
    case f.object.pricing_type
    when "fixed"
      f.inputs "Fixed Pricing" do
        f.fields_for :item_pricings, pricing do |pf|
          pf.input :default_fixed_price, label: "Fixed Price"
        end
      end
  
    when "open"
      f.inputs "Open Pricing" do
        f.fields_for :item_pricings, pricing do |pf|
          pf.input :open_parameters_label_as_string,
                   as: :text,
                   label: "Parameters name (one per line)",
                   input_html: {
                     rows: 5,
                     value: pf.object.open_parameters_label_as_string
                   }
        end
      end
  
    when "fixed_open"
      f.inputs "Fixed + Open Pricing" do
        f.fields_for :item_pricings, pricing do |pf|
          pf.input :default_fixed_price, label: "Fixed Price"
          pf.input :fixed_parameters, as: :text, label: "Fixed Parameters (JSON)"
          pf.input :formula_parameters, as: :text, label: "Formula Parameters (JSON)"
          pf.input :calculation_formula, label: "Calculation Formula"
        end
      end
  
      if f.object.item_pricings.present?
        panel "Existing Parameters" do
          ul do
            f.object.item_pricings.each do |ipr|
              li "Formula: #{ipr.formula_parameters}, Calculation: #{ipr.calculation_formula}"
            end
          end
        end
      else
        div "No parameters yet."
      end
  
      f.button "Add Parameter", type: "button",
        onclick: "window.location='#{}'"
  
    f.actions
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