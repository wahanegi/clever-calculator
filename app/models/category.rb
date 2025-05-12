class Category < ApplicationRecord
  has_many :items, dependent: :nullify

  ASCII_CHARACTERS = /\A[[:ascii:]]*\z/

  has_many :items, dependent: :nullify
  has_many :quote_categories, dependent: :destroy
  has_many :quotes, through: :quote_categories

  normalizes :name, with: ->(name) { name.gsub(/\s+/, ' ').strip }

  after_update :disable_related_items_if_disabled

  validates :name, presence: true, length: { maximum: 50 }
  validates :name, uniqueness: { scope: :is_disabled,
                                 case_sensitive: false,
                                 conditions: -> { where(is_disabled: false) },
                                 message: "A category with this name already exists" },
                   if: -> { name.present? }
  validates :name, format: { with: ASCII_CHARACTERS,
                             message: "must contain only ASCII characters" },
                   if: -> { name.present? }

  scope :enabled, -> { where(is_disabled: false) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id id_value is_disabled name updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def disable_related_items_if_disabled
    return unless saved_change_to_is_disabled? && is_disabled?

    items.find_each { |item| item.update(is_disabled: true) }
  end
end
