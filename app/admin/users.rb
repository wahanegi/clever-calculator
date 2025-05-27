ActiveAdmin.register User do
  permit_params do
    params = [ :name, :email, :phone ]
    params += [ :password, :password_confirmation ] if request.params.dig(:user, :password).present?
    params
  end

  action_item :back, only: [ :show ] do
    link_to "Back to Users", admin_users_path
  end

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :email
      row :phone
      row :created_at
    end
  end

  filter :name
  filter :email

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :phone
      f.input :password, required: f.object.new_record?
      f.input :password_confirmation, required: f.object.new_record?
    end
    f.actions
  end

  controller do
    def update
      @user = User.find(permitted_params[:id])
      if update_user
        redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
      else
        render :edit
      end
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: 'User was successfully created.'
      else
        render :new
      end
    end

    private

    # The `update_user` method checks if the password is provided in the update parameters.
    # - if the password is provided, it updates the user with the new password.
    # - if no password is provided, it uses the `update_without_password` method
    #   to update the user without changing the password.
    def update_user
      if user_params[:password].present?
        @user.update(user_params)
      else
        @user.update_without_password(user_params)
      end
    end

    def user_params
      permitted_params[:user]
    end
  end
end
