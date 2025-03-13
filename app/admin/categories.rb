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
      item 'View', admin_category_path(id: category.id), class: 'member_link'
      item 'Edit', edit_admin_category_path(id: category.id), class: 'member_link'
      if category.is_disabled
        item 'Disable', admin_category_path(id: category.id, category: { is_disabled: false }),
             method: :put,
             class: 'member_link'
      end
    end
  end
end
