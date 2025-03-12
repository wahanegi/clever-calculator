ActiveAdmin.register Category do
  permit_params :name, :description, :is_disabled

  batch_action :destroy, false

  filter :name
  filter :is_disabled

  index do
    selectable_column
    id_column
    column 'Category Name', :name
    column :is_disabled
    column :created_at
    column :updated_at
    column :items_count
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
    columns do
      column span: 4 do
        f.inputs do
          f.input :name
          f.input :description
        end
        f.actions
      end
      column span: 2 do
        category_navigation = edit_action? ? edit_admin_category_path(resource) : new_admin_category_path

        panel link_to('Add Item', new_admin_item_path('origin': category_navigation)) do
          items = edit_action? ? resource.items : Item.where(category_id: nil)

          if items.present?
            table_for items do
              column 'Item name', :name do |item|
                link_to item.name, edit_admin_item_path(item, 'origin': category_navigation)
              end
              column 'Item description', :description
            end
          else
            div 'No items found'
          end
        end
      end
    end
  end

  show do
    columns do
      column span: 4 do
        attributes_table do
          row :name
          row :description
          row :is_disabled
          row :created_at
          row :updated_at
        end
      end
      column span: 2 do
        panel 'Items' do
          if resource.items.present?
            table_for resource.items do
              column 'Item name', :name do |item|
                link_to item.name, admin_item_path(item)
              end
              column 'Item description', :description
            end
          else
            div 'No items found'
          end
        end
      end
    end
  end

  # Remove the destroy button only on the show page
  config.action_items.delete_if { |item| item.name == :destroy && item.display_on?(:show) }

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
      redirect_to admin_categories_path, notice: "Category was successfully #{resource.is_disabled? ? 'disabled' : 'enabled'}"
    else
      redirect_to admin_categories_path, alert: "Failed to #{resource.is_disabled? ? 'disable' : 'enable'} category"
    end
  end

  controller do
    helper ActiveAdmin::ResourceHelper
    def create
      @category = Category.new(permitted_params[:category])

      if @category.save
        redirect_to admin_categories_path, notice: 'Category was successfully created'
      else
        render :new
      end
    end
  end
end
