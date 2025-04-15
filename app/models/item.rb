class Item < ApplicationRecord
  belongs_to :category, optional: true

  validates :name, presence: true
  validates :name, uniqueness: { scope: :category_id, message: "Item name must be unique within category" }
  validate :category_must_be_active

  def self.ransackable_attributes(_auth_object = nil)
    %w[category_id created_at id is_disabled name updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["category"]
  end  

  def category_must_be_active
    if category&.is_disabled?
      errors.add(:category, "is disabled")
    end
  end
end
