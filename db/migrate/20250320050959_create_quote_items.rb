class CreateQuoteItems < ActiveRecord::Migration[8.0]
  def change
    create_table :quote_items do |t|
      t.references :quote, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.references :item_pricing, null: false, foreign_key: true
      t.jsonb :open_parameters, default: {}
      t.decimal :price, precision: 10, scale: 2, null: false
      t.decimal :discount, precision: 5, scale: 2, default: 0.00, null: false
      t.decimal :final_price, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
