ActiveAdmin.register Item do
    permit_params :name, :pricing_type, :category_id, :is_disable

    filter :name_cont, as: :string, label: "Product Name"
    filter :category, as: :select, collection: -> { Category.pluck(:name, :id) }, label: "Category"
    filter :pricing_type, as: :select, collection: Item.pricing_types, label: "Pricing Type"

    index do
        selectable_column
        id_column
        column :name
        column :pricing_type
        column "Category", sortable: :category_id do |item|
          link_to item.category.name, admin_category_path(item.category) if item.category
        end
        column :is_disable
        column :created_at
        column :updated_at
        actions defaults: false do |item|
            links = []
            links << link_to("View", admin_item_path(item), class: "member_link")
            links << link_to("Edit", edit_admin_item_path(item), class: "member_link")
            links << link_to("Disable", "#", class: "member_link disable-link")
          end
    end

    show do
        attributes_table do
          row :id
          row :name
          row :pricing_type
          row "Category" do |item|
            link_to item.category.name, admin_category_path(item.category) if item.category
          end
          row :is_disable
          row :created_at
          row :updated_at
          actions defaults: true do |item|
      if item.is_disable
        link_to "Enable", disable_admin_item_path(item), method: :put, class: "member_link"
      else
        link_to "Disable", disable_admin_item_path(item), method: :put, class: "member_link"
      end
    end
        end
    end
end
