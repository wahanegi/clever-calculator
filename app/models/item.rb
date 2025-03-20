class Item < ApplicationRecord
  belongs_to :category, optional: true
  has_many :quote_items, dependent: :destroy
  has_many :item_pricings
  before_validation :build_default_pricing, if: -> { item_pricings.blank? }

  after_initialize :ensure_one_pricing_for_fixed, if: :new_record?

  accepts_nested_attributes_for :item_pricings, allow_destroy: true

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
  def build_default_pricing
    new_pricing = item_pricings.build
    new_pricing.item = self 
    self.item_pricings << new_pricing 
  end

  def ensure_one_pricing_for_fixed
    if fixed? && item_pricings.blank?
      item_pricings.build(default_fixed_price: '')
    end
  end
end
