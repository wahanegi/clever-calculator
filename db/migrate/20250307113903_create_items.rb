class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :description
      t.integer :pricing_type, default: 0
      t.references :category, foreign_key: true
      t.boolean :is_disabled, default: false, null: false

      t.timestamps
    end
    add_index :items, %i[name category_id], unique: true
  end
end
