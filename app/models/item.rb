class Item < ApplicationRecord
  belongs_to :category, optional: true, counter_cache: true
  has_many :quote_items, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :name, uniqueness: { scope: :category_id, message: "Item name must be unique within category" }
  validate :category_must_be_active
  validate :fixed_parameters_values_must_be_numeric
  validate :pricing_options_values_must_be_numeric
  validates :calculation_formula, presence: true, if: :requires_calculation_formula?
  validates_with ItemFormulaSyntaxValidator

  scope :enabled, -> { where(is_disabled: false) }
  scope :without_category, -> { where(category_id: nil) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[category_id created_at id is_disabled name updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["category"]
  end

  private

  def category_must_be_active
    return unless category&.is_disabled?

    errors.add(:category, "is disabled")
  end

  def fixed_parameters_values_must_be_numeric
    return if fixed_parameters.blank?

    unless fixed_parameters.is_a?(Hash)
      errors.add(:fixed_parameters, "must be a JSON object")
      return
    end

    fixed_parameters.each do |key, val|
      errors.add(:fixed_parameters, "value for '#{key}' must be a number") unless numeric?(val)
    end
  end

  def pricing_options_values_must_be_numeric
    return if pricing_options.blank?

    unless pricing_options.is_a?(Hash)
      errors.add(:pricing_options, "must be a JSON object")
      return
    end

    pricing_options.each do |key, data|
      validate_pricing_option_structure(key, data)
    end
  end

  def validate_pricing_option_structure(key, data)
    return unless pricing_option_structure_valid?(key, data)

    data["options"].each_with_index do |opt, index|
      validate_pricing_option_entry(key, opt, index)
    end
  end

  def pricing_option_structure_valid?(key, data)
    unless data.is_a?(Hash)
      errors.add(:pricing_options, "entry for '#{key}' must be a JSON object")
      return false
    end

    unless data["options"].is_a?(Array)
      errors.add(:pricing_options, "options for '#{key}' must be an array")
      return false
    end

    true
  end

  def validate_pricing_option_entry(key, opt, index)
    unless opt.is_a?(Hash) && opt["description"] && opt["value"]
      errors.add(:pricing_options, "option #{index} in '#{key}' must include 'description' and 'value'")
      return
    end

    return if numeric?(opt["value"])

    errors.add(:pricing_options, "value '#{opt['value']}' in option '#{opt['description']}' (#{key}) must be numeric")
  end

  def numeric?(val)
    return true if val.is_a?(Numeric)
    return false unless val.is_a?(String)

    begin
      Float(val)
      true
    rescue ArgumentError, TypeError
      false
    end
  end

  def requires_calculation_formula?
    is_fixed || is_open || is_selectable_options
  end
end
