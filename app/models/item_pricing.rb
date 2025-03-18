class ItemPricing < ApplicationRecord
  belongs_to :item, inverse_of: :item_pricings
  delegate :pricing_type, to: :item, allow_nil: true

  attr_accessor :parameter_type,
                :fixed_parameter_name, :fixed_parameter_value,
                :open_parameter_name,
                :select_parameter_name,
                *(1..10).map { |i| ["option_description_#{i}", "option_value_#{i}"] }.flatten

  validates :item, presence: true
  validates :default_fixed_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :calculation_formula, presence: true, if: -> { item&.pricing_type == "fixed_open" }
  validates :default_fixed_price, presence: true, if: -> { pricing_type == "fixed" }

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id item_id default_fixed_price fixed_parameters is_selectable_options
      pricing_options is_open open_parameters_label formula_parameters
      calculation_formula created_at updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["item"]
  end
end
