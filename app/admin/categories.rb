ActiveAdmin.register Category do
  permit_params :name, :description, :is_disabled

  actions :all, except: :destroy

  filter :name
  filter :is_disabled, label: 'Disabled', as: :select, collection: { 'True' => true, 'False' => false }

  index do
    id_column
    column :name
    column('Disabled') { |item| status_tag item.is_disabled, label: item.is_disabled? ? 'True' : 'False' }
    column :items_count
    column :created_at
    column :updated_at
    actions defaults: false do |category|
      item 'View', admin_category_path(category), class: 'view_link member_link'
      item 'Edit', edit_admin_category_path(category), class: 'edit_link member_link'
      if category.is_disabled?
        item 'Enable', toggle_admin_category_path(category),
             method: :put,
             class: 'enable_link member_link'
      else
        item 'Disable', toggle_admin_category_path(category),
             method: :put,
             class: 'disable_link member_link',
             data: { confirm: "Are you sure you want to disable the category '#{category.name}'?" }
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name, hint: "Maximum 50 characters"
      f.input :description
    end
    f.actions

    if edit_action?
      panel "Items" do
        div do
          link_to 'Add Item', new_admin_item_path(category_id: resource.id), class: 'button'
        end

        items = resource.items

        if items.any?
          table_for items do
            column 'Item name' do |item|
              link_to item.name, edit_admin_item_path(item)
            end
            column 'Item description', :description
          end
        else
          "Items not found"
        end
      end
    end
  end

  show do
    attributes_table do
      row :name
      row :description
      row('Disabled') { |item| status_tag item.is_disabled, label: item.is_disabled? ? 'True' : 'False' }
      row :created_at
      row :updated_at
    end

    panel "Items" do
      div do
        link_to 'Add Item', new_admin_item_path(category_id: resource.id), class: 'button'
      end

      items = resource.items

      if items.any?
        table_for items do
          column 'Item name' do |item|
            link_to item.name, admin_item_path(item)
          end
          column 'Item description', :description
        end
      else
        "Items not found"
      end
    end
  end

  action_item :toggle, only: :show do
    if resource.is_disabled?
      link_to "Enable Category", toggle_admin_category_path(resource), method: :put
    else
      link_to "Disable Category", toggle_admin_category_path(resource),
              method: :put,
              data: { confirm: "Are you sure you want to disable the category '#{resource.name}'?" }
    end
  end

  action_item :back, only: :show do
    link_to "Back To Categories", admin_categories_path
  end

  member_action :toggle, method: :put do
    resource.toggle(:is_disabled)

    if resource.save
      # rubocop:disable Rails/SkipsModelValidations
      resource.items.update_all(is_disabled: true) if resource.is_disabled?
      # rubocop:enable Rails/SkipsModelValidations

      redirect_to admin_categories_path, notice: "Category was successfully #{resource.is_disabled? ? 'disabled' : 'enabled'}."
    else
      redirect_to admin_categories_path, alert: resource.errors.messages_for(:name)
    end
  end

  controller do
    helper ActiveAdmin::ActionCheckHelper
  end
end
