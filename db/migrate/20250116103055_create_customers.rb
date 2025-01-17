class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :company_name
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :position
      t.string :address
      t.text :notes

      t.timestamps
    end
    add_index :customers, :company_name, unique: true
  end
end
