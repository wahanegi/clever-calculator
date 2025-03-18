class AddTrackableToAdminUsers < ActiveRecord::Migration[8.0]
  def change
    change_table :admin_users, bulk: true do |t|
      t.column :sign_in_count, :integer, default: 0, null: false
      t.column :current_sign_in_at, :datetime
      t.column :last_sign_in_at, :datetime
      t.column :current_sign_in_ip, :string
      t.column :last_sign_in_ip, :string
    end
  end
end
