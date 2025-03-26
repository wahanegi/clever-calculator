class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :is_disabled, default: false, null: false

      t.timestamps
    end
    add_index :categories, :is_disabled
    add_index :categories, [:name], unique: true, where: "is_disabled = false"
  end
end
