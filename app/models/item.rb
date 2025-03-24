class Item < ApplicationRecord
  belongs_to :category, optional: true
  has_many :item_pricings

  after_initialize :build_default_item_pricing, if: :new_record?
  
  accepts_nested_attributes_for :item_pricings

  enum :pricing_type, { fixed: 0, open: 1, fixed_open: 2 }, default: :fixed

  validates :name, presence: true
  validates :pricing_type, presence: true
  validates :name, uniqueness: { scope: :category_id, message: "Item name must be unique within category" }


  def self.ransackable_attributes(_auth_object = nil)
    %w[category_id created_at id is_disabled name pricing_type updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["category"]
  end

  private

  def build_default_item_pricing
    item_pricings.build if item_pricings.blank?
  end
end
