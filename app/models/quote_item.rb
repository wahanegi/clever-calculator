class QuoteItem < ApplicationRecord
  attr_accessor :open_param_values, :select_param_values

  belongs_to :quote
  belongs_to :item

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }, unless: :destroyed?
  validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :final_price, presence: true, numericality: { greater_than_or_equal_to: 0 }, unless: :destroyed?

  before_validation :compile_pricing_parameters
  before_validation :calculate_price_from_formula, if: -> { item_requires_formula? }
  before_validation :calculate_final_price, if: -> { price.present? && discount.present? }

  after_save :recalculate_quote_total_price
  after_destroy :recalculate_quote_total_price

  def compile_pricing_parameters
    return unless item

    fixed = item.fixed_parameters || {}
    open = open_param_values || { item.open_parameters_label&.first => 0 }
    select = select_param_values || { item.pricing_options&.keys&.first => 0 }

    self.pricing_parameters = fixed.merge(open, select).reject { |k, v| k.blank? || v.blank? }
  end

  def calculate_price_from_formula
    return unless item_requires_formula?

    calculator = Dentaku::Calculator.new
    self.price = calculator.evaluate(item.calculation_formula, pricing_parameters)
  rescue Dentaku::UnboundVariableError => e
    errors.add(:price, "missing variable(s): #{e.unbound_variables.join(', ')}")
  rescue StandardError => e
    errors.add(:price, "could not calculate price: #{e.message}")
  end

  private

  def calculate_final_price
    self.final_price = price - (price * (discount / 100))
  end

  def recalculate_quote_total_price
    quote.recalculate_total_price
  end

  def item_requires_formula?
    item&.calculation_formula.present?
  end
end
