class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :description
      t.references :category, foreign_key: true

      t.jsonb :fixed_parameters, default: {}
      t.jsonb :pricing_options, default: {}
      t.boolean :is_disabled, default: false, null: false
      t.boolean :is_fixed, default: false
      t.boolean :is_open, default: false
      t.boolean :is_selectable_options, default: false
      t.text :open_parameters_label, array: true, default: []
      t.text :formula_parameters, array: true, default: []
      t.string :calculation_formula

      t.timestamps
    end
    add_index :items, %i[name category_id], unique: true
  end
end
