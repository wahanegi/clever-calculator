class Item < ApplicationRecord
  belongs_to :category, optional: true
  has_many :quote_items, dependent: :destroy

  validates :name, presence: true
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
    validate_jsonb_numeric_values(:fixed_parameters)
  end

  def pricing_options_values_must_be_numeric
    validate_jsonb_numeric_values(:pricing_options) do |key_path, val|
      key_path.last != 'value_label' && !numeric?(val)
    end
  end

  def validate_jsonb_numeric_values(attribute, &block)
    value = self[attribute] || {}
    unless value.is_a?(Hash)
      errors.add(attribute, "must be a JSON object")
      return
    end

    validate_nested_numeric_values(value, attribute, [], &block)
  end

  def validate_nested_numeric_values(hash, attribute, key_path = [], &block)
    hash.each do |key, val|
      current_path = key_path + [key]
      if val.is_a?(Hash)
        validate_nested_numeric_values(val, attribute, current_path, &block)
      else
        should_error = block_given? ? yield(current_path, val) : !numeric?(val)
        errors.add(attribute, "value for '#{current_path.join(' -> ')}' must be a number") if should_error
      end
    end
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
