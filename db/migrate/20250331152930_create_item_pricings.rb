class CreateItemPricings < ActiveRecord::Migration[8.0]
  def change
    create_table :item_pricings do |t|
      t.references :item, null: false, foreign_key: true
      t.decimal :default_fixed_price, precision: 10, scale: 2
      t.json :fixed_parameters, default: {}
      t.boolean :is_selectable_options, default: false
      t.jsonb :pricing_options, default: {}
      t.boolean :is_open, default: false
      t.text :open_parameters_label, array: true, default: []
      t.text :formula_parameters, array: true, default: []
      t.string :calculation_formula

      t.timestamps
    end
  end
end
