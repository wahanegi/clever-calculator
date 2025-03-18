ActiveAdmin.register User do
  permit_params do
    params = [:name, :email]
    params += [:password, :password_confirmation] if request.params.dig(:user, :password).present?
    params
  end

  action_item :back, only: [:show] do
    link_to "Back", admin_users_path
  end

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :email
      row :created_at
    end
  end

  filter :name
  filter :email

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :password, required: f.object.new_record?
      f.input :password_confirmation, required: f.object.new_record?
    end
    f.actions
  end
end
