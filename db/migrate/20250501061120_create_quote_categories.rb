class CreateQuoteCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :quote_categories do |t|
      t.references :quote, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
