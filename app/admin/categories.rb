ActiveAdmin.register Category do
  permit_params :name, :description, :is_disabled

  actions :all, except: :destroy

  filter :name
  filter :is_disabled, label: 'Disabled'

  index do
    id_column
    column 'Category Name', :name
    column 'Disabled', :is_disabled
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
      f.input :name
      f.input :description
    end
    f.actions
  end

  show do
    attributes_table do
      row('Category Name', &:name)
      row :description
      row('Disabled', &:is_disabled)
      row :created_at
      row :updated_at
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
