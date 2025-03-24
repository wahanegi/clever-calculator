class Category < ApplicationRecord
  ASCII_CHARACTERS = /\A[[:ascii:]]*\z/
  BETWEEN_WORDS_SPACES = /\A\s*\S+(?:\s\S+)*\s*\z/
  START_SINGLE_SPACE = /\A\S+/
  END_SINGLE_SPACE = /\S+\z/

  validates :name, presence: true
  validates :name, uniqueness: { scope: :is_disabled,
                                 case_sensitive: false,
                                 conditions: -> { where(is_disabled: false) },
                                 message: "A category with this name already exists" },
                   if: -> { name.present? }
  validates :name, format: { with: ASCII_CHARACTERS,
                             message: "must contain only ASCII characters" },
                   if: -> { name.present? }
  validates :name, format: { with: BETWEEN_WORDS_SPACES,
                             message: "must contain only a single space between words" },
                   if: -> { name.present? }
  validates :name, format: { with: START_SINGLE_SPACE,
                             message: "must not start with space(s)" },
                   if: -> { name.present? }
  validates :name, format: { with: END_SINGLE_SPACE,
                             message: "must not end with space(s)" },
                   if: -> { name.present? }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id id_value is_disabled name updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
