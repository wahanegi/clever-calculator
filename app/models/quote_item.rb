class QuoteItem < ApplicationRecord
  attr_accessor :open_param_values, :select_param_values

  belongs_to :quote
  belongs_to :item

  store_accessor :pricing_parameters, :fixed_parameters, :open_parameters_label, :pricing_options

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :final_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :calculate_final_price, if: -> { should_recalculate_final_price? }
  before_validation :compile_pricing_parameters

  def compile_pricing_parameters
    return unless item

    combined = {}

    combined.merge!(item.fixed_parameters || {})
    (open_param_values || {}).each do |k, v|
      combined[k] = v
    end

    (select_param_values || {}).each do |k, v|
      combined[k] = v
    end

    self.pricing_parameters = combined
  end

  after_save :recalculate_quote_total_price
  after_destroy :recalculate_quote_total_price

  private

  def calculate_final_price
    self.final_price = price - (price * (discount / 100))
  end

  def should_recalculate_final_price?
    price.present? && discount.present? && (price_changed? || discount_changed?)
  end

  def recalculate_quote_total_price
    quote.recalculate_total_price
  end
end
