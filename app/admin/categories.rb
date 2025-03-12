ActiveAdmin.register Category do
  permit_params :name, :description, :is_disabled

  batch_action :destroy, false

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
        item 'Disable', disable_admin_category_path(category),
             method: :put,
             class: 'member_link',
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

  # Remove the destroy button only on the show page
  config.action_items.delete_if { |item| item.name == :destroy && item.display_on?(:show) }

  action_item :disable, only: :show, if: -> { !resource.is_disabled? } do
    link_to "Disable Category", disable_admin_category_path(resource),
            method: :put,
            data: { confirm: "Are you sure you want to disable the category '#{resource.name}'?" }
  end

  action_item :back, only: :show do
    link_to "Back", admin_categories_path
  end

  member_action :disable, method: :put do
    if resource.update(is_disabled: true)
      redirect_to admin_categories_path, notice: 'Category was successfully disabled.'
    else
      redirect_to admin_category_path(resource), notice: resource.errors.full_messages
    end
  end

  controller do
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
