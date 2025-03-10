class ItemPricing < ApplicationRecord
    belongs_to :item
  
    validates :item_id, presence: true
    validates :default_fixed_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :calculation_formula, presence: true, if: -> { item&.pricing_type == "fixed_open" }
    validates :default_fixed_price, presence: true, if: -> { !is_open }
  end
  