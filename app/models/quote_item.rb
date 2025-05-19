class QuoteItem < ApplicationRecord
  MAX_ALLOWED_PRICE = 99_999_999.99
  attr_accessor :open_param_values, :select_param_values

  belongs_to :quote
  belongs_to :item
  has_one :note, dependent: :destroy
  accepts_nested_attributes_for :note, allow_destroy: true

  validates :price,
            presence: {
              message: "Could not be calculated – please make sure all required parameters are filled in"
            },
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: MAX_ALLOWED_PRICE,
              message: "Must be a valid number between 0 and #{MAX_ALLOWED_PRICE} (check your parameter inputs)"
            },
            unless: -> { destroyed? || errors[:price].present? }
  validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :final_price, presence: true, numericality: { greater_than_or_equal_to: 0 }, unless: :destroyed?

  before_validation :compile_pricing_parameters
  before_validation :calculate_price_from_formula, if: -> { item_requires_formula? }
  before_validation :calculate_final_price, if: -> { price.present? && discount.present? }
  before_validation :assign_quote_to_note

  after_save :recalculate_quote_total_price
  after_destroy :recalculate_quote_total_price

  def compile_pricing_parameters
    return unless item

    fixed, open, select = assemble_parameters

    self.pricing_parameters = fixed.merge(open, select)
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
    calculated = price - (price * (discount / 100))
    if calculated > MAX_ALLOWED_PRICE
      errors.add(:final_price, "exceeds the allowed maximum of #{MAX_ALLOWED_PRICE}")
    else
      self.final_price = calculated
    end
  end

  def recalculate_quote_total_price
    quote.recalculate_total_price
  end

  def item_requires_formula?
    item&.calculation_formula.present?
  end

  def assemble_parameters
    fixed = item.fixed_parameters || {}
    open = fetch_open_parameters
    select = fetch_select_parameters

    [fixed, open, select]
  end

  def fetch_open_parameters
    return {} if item.open_parameters_label.blank?

    Array(item.open_parameters_label).index_with do |label|
      open_param_values&.dig(label) || 0
    end
  end

  def fetch_select_parameters
    return {} if item.pricing_options.blank?

    item.pricing_options.keys.index_with do |key|
      select_param_values&.dig(key) || 0
    end
  end

  def assign_quote_to_note
    return unless note.present? && quote.present?

    note.quote ||= quote
  end
end
