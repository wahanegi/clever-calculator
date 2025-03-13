ActiveAdmin.register Item do
  permit_params :name, :pricing_type, :category_id, :is_disable,
                item_pricing_attributes: [:id, :default_fixed_price, :fixed_parameters, :is_selectable_options,
                                          :pricing_options, :open_parameters_label, :formula_parameters,
                                          :calculation_formula, :is_open]

  filter :name_cont, as: :string, label: "Product Name"
  filter :category, as: :select, collection: -> { Category.pluck(:name, :id) }, label: "Category"
  filter :pricing_type, as: :select, collection: Item.pricing_types, label: "Pricing Type"
  # filter :is_disabled, as: :boolean, label: "Disabled"

  index do
    selectable_column
    id_column
    column :name
    column :pricing_type
    column "Category", sortable: :category_id do |item|
      link_to item.category.name, admin_category_path(item.category) if item.category
    end
    column "Disabled", :is_disabled do |item|
      status_tag(item.is_disabled? ? "True" : "False")
    end
    column :created_at
    column :updated_at
    actions defaults: false do |item|
      links = []
      links << link_to("View", admin_item_path(item), class: "member_link")
      links << link_to("Edit", edit_admin_item_path(item), class: "member_link")
      links << link_to(item.is_disabled? ? "Enable" : "Disable", toggle_admin_item_path(item), method: :put, data: { confirm: "Are you sure?" }, class: "member_link")
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
                            collection: [["No Category", nil]] + Category.pluck(:name, :id),
                            include_blank: false
      f.input :pricing_type, as: :select, collection: Item.pricing_types.keys, prompt: "Select Pricing Type"
    end

    f.inputs "Pricing Details", for: [:item_pricing, f.object.item_pricing || ItemPricing.new] do |pf|
      case f.object.pricing_type
      when "fixed"
        pf.input :default_fixed_price, label: "Fixed Price"
      when "fixed_open"
        # TODO: Додати функцію переходу для кнопки
        f.button "Add Parameters"
        pf.input :fixed_parameters, as: :text, label: "Fixed Parameters"
        pf.input :open_parameters_label, as: :text, label: "Open Parameters"
        pf.input :is_selectable_options, label: "Has Selectable Options"
        pf.input :pricing_options, as: :text, label: "Pricing Options",
                                   input_html: { disabled: !pf.object.is_selectable_options }
        pf.input :formula_parameters, label: "Formula Parameters"
        pf.input :calculation_formula, label: "Calculation Formula"
      when "open"
        pf.input :open_parameters_label, as: :text, label: "Open Parameters"
      end
    end
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
    link_to(resource.is_disabled? ? "Enable item" : "Disable item", toggle_admin_item_path(resource), method: :put, data: { confirm: "Are you sure?" })
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

    panel "Pricing Details" do
      if item.respond_to?(:item_pricing) && item.item_pricing.present?
        item_pricing = item.item_pricing
        attributes_table_for item_pricing do
          case item.pricing_type
          when "fixed"
            row "Price" do
              item_pricing.default_fixed_price
            end
          when "fixed_open"
            row "Fixed Parameters" do
              pre JSON.pretty_generate(item_pricing.fixed_parameters)
            end
            row "Open Parameters" do
              item_pricing.open_parameters_label.join(", ")
            end
            if item_pricing.is_selectable_options
              row "Selectable Options" do
                pre JSON.pretty_generate(item_pricing.pricing_options)
              end
            end
            row "Formula Parameters" do
              pre JSON.pretty_generate(item_pricing.formula_parameters)
            end
            row "Calculation Formula" do
              item_pricing.calculation_formula
            end
          when "open"
            div "This item has open pricing, no additional parameters are displayed."
          end
        end
      else
        div "No pricing details available."
      end
    end
  end
end
