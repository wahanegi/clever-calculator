class QuoteItem < ApplicationRecord
  belongs_to :quote
  belongs_to :item
  belongs_to :item_pricing

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :final_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :calculate_final_price, if: -> { should_recalculate_final_price? }

  private

  def calculate_final_price
    self.final_price = price - (price * (discount / 100))
  end

  def should_recalculate_final_price?
    price.present? && discount.present? && (price_changed? || discount_changed?)
  end
end
