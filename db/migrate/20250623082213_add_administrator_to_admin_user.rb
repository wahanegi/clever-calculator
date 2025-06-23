class AddAdministratorToAdminUser < ActiveRecord::Migration[8.0]
  def change
    add_column :admin_users, :administrator, :boolean, default: false
  end
end
