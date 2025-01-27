ActiveAdmin.register Customer do
  permit_params :company_name, :first_name, :last_name, :email, :position, :address, :notes

  index do
    selectable_column
    id_column
    column :company_name
    column :first_name
    column :last_name
    column :email
    column :position
    column :address
    actions
  end

  filter :company_name
  filter :first_name
  filter :last_name
  filter :email
  filter :position
  filter :address
  filter :notes

  form do |f|
    f.inputs do
      f.input :company_name
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :position
      f.input :address
      f.input :notes
    end
    f.actions
  end
end
