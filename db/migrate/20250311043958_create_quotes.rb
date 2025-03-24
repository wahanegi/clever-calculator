class CreateQuotes < ActiveRecord::Migration[8.0]
  def change
    create_table :quotes do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :total_price, precision: 10, scale: 2, default: 0.00, null: false

      t.timestamps
    end
  end
end
