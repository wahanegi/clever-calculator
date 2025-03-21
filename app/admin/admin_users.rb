ActiveAdmin.register AdminUser do
  permit_params :email, :name, :password

  action_item :back, only: :show do
    link_to 'Back to Admin Users', admin_admin_users_path
  end

  filter :name
  filter :email

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :created_at
    column :last_sign_in_at
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

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :password, required: resource.new_record?
    end
    f.actions
  end

  controller do
    def update
      @admin_user = AdminUser.find(permitted_params[:id])

      if update_admin_user
        redirect_to admin_admin_user_path(@admin_user), notice: 'Admin user was successfully updated.'
      else
        render :edit
      end
    end

    def create
      @admin_user = AdminUser.new(admin_user_params)

      if @admin_user.save
        redirect_to admin_admin_users_path, notice: 'Admin user was successfully created.'
      else
        render :new
      end
    end

    private

    def update_admin_user
      if admin_user_params[:password].present?
        @admin_user.update(admin_user_params)
      else
        @admin_user.update_without_password(admin_user_params)
      end
    end

    def admin_user_params
      permitted_params[:admin_user]
    end
  end
end
