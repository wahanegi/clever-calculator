class Item < ApplicationRecord
  belongs_to :category, optional: true

  validates :name, presence: true
  validates :name, uniqueness: { scope: :category_id, message: "Item name must be unique within category" }

  def self.ransackable_attributes(_auth_object = nil)
    %w[category_id created_at id is_disabled name updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["category"]
  end  
end
