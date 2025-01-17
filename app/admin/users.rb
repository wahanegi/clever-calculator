ActiveAdmin.register User do
  permit_params :email, :name, :password, :password_confirmation

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :name
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
