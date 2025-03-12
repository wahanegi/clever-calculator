ActiveAdmin.register Category do
  permit_params :name, :description, :is_disabled

  filter :name

  index do
    selectable_column
    id_column
    column 'Category Name', :name
    column :is_disabled
    column :created_at
    column :updated_at
    actions defaults: false do |category|
      item 'View', admin_category_path(category), class: 'member_link'
      item 'Edit', edit_admin_category_path(category), class: 'member_link'
      unless category.is_disabled
        item 'Disable', disable_admin_category_path(category), method: :put,
             class: 'member_link'
      end
    end
  end

  # Remove the destroy button only on the show page
  config.action_items.delete_if { |item| item.name == :destroy && item.display_on?(:show) }

  action_item :disable, only: :show, if: -> { !resource.is_disabled? } do
    link_to "Disable Category", disable_admin_category_path(resource), method: :put
  end

  action_item :back, only: :show do
    link_to "Back", admin_categories_path
  end

  member_action :disable, method: :put do
    if resource.update(is_disabled: true)
      redirect_to admin_categories_path, notice: 'Category was successfully disabled.'
    else
      redirect_to admin_category_path(resource), notice: resource.errors
    end
  end
end
