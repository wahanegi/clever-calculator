class RemovePrecisionFromDecimalFields < ActiveRecord::Migration[8.0]
  def up
    change_table :quote_items, bulk: true do |t|
      t.change :price, :decimal, precision: 14, scale: 2, null: false
      t.change :final_price, :decimal, precision: 14, scale: 2, null: false
    end

    change_table :quotes, bulk: true do |t|
      t.change :total_price, :decimal, precision: 14, scale: 2, default: 0.0, null: false
    end
  end
end
