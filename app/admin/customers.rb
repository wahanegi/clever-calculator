ActiveAdmin.register Customer do
  permit_params :company_name, :first_name, :last_name, :email, :position, :address, :notes, :logo
  includes logo_attachment: :blob

  index do
    selectable_column
    id_column
    column :logo do |customer|
      display_image_or_fallback customer.logo
    end
    column :company_name, class: 'break-word'
    column :full_name, sortable: :first_name
    column :email, class: 'break-word'
    column :position
    column :address, class: 'break-word'
    actions
  end

  show do
    attributes_table do
      row :logo do |customer|
        display_image_or_fallback customer.logo
      end
      row :company_name
      row :full_name
      row :email
      row :position
      row :address
      row :notes
    end
  end

  filter :company_name
  filter :first_name
  filter :last_name
  filter :email
  filter :position
  filter :address
  filter :notes

  form do |f|
    if edit_action?
      panel 'Logo' do
        display_image_or_fallback customer.logo
      end
    end

    f.inputs do
      f.input :logo, as: :file, input_html: { accept: Customer::ALLOWED_LOGO_TYPES.join(',') }
      f.input :company_name, hint: "Maximum 50 characters"
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :position
      f.input :address
      f.input :notes
    end
    f.actions
  end

  action_item :back, only: :show do
    link_to "Back to Customers", admin_customers_path
  end

  controller do
    helper ActiveAdmin::ImagePreviewHelper
    helper ActiveAdmin::ActionCheckHelper
  end
end
