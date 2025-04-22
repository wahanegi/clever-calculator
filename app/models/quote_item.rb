class QuoteItem < ApplicationRecord
    belongs_to :quote
    belongs_to :item
  
    validates :quote_id, presence: true
    validates :item_id, presence: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
    validates :final_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  end
  