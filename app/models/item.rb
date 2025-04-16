class Item < ApplicationRecord
  belongs_to :category, optional: true

  validates :name, presence: true
  validates :name, uniqueness: { scope: :category_id, message: "Item name must be unique within category" }
  validate :category_must_be_active
  validate :fixed_parameters_values_must_be_numeric
  validate :pricing_options_values_must_be_numeric

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
    validate_jsonb_numeric_values(:pricing_options)
  end

  def validate_jsonb_numeric_values(attribute)
    value = self[attribute] || {}
    unless value.is_a?(Hash)
      errors.add(attribute, "must be a JSON object")
      return
    end

    validate_nested_numeric_values(value, attribute)
  end

  def validate_nested_numeric_values(hash, attribute, key_path = [])
    hash.each do |key, val|
      current_path = key_path + [key]
      if val.is_a?(Hash)
        validate_nested_numeric_values(val, attribute, current_path)
      else
        errors.add(attribute, "value for '#{current_path.join(' -> ')}' must be a number") unless numeric?(val)
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
end
