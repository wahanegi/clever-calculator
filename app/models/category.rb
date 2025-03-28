class Category < ApplicationRecord
  ASCII_CHARACTERS = /\A[[:ascii:]]*\z/

  normalizes :name, with: ->(name) { name.gsub(/\s+/, ' ').strip }

  validates :name, presence: true
  validates :name, uniqueness: { scope: :is_disabled,
                                 case_sensitive: false,
                                 conditions: -> { where(is_disabled: false) },
                                 message: "A category with this name already exists" },
                   if: -> { name.present? }
  validates :name, format: { with: ASCII_CHARACTERS,
                             message: "must contain only ASCII characters" },
                   if: -> { name.present? }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id id_value is_disabled name updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
