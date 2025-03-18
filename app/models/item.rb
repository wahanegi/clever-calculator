class Item < ApplicationRecord
  belongs_to :category, optional: true
  has_many :item_pricings
  before_validation :build_default_pricing, if: -> { item_pricings.blank? }
  before_validation :log_validation_errors
  after_validation :log_validation_errors

  accepts_nested_attributes_for :item_pricings, allow_destroy: true

  enum :pricing_type, { fixed: 0, open: 1, fixed_open: 2 }


  validates :name, presence: true
  validates :pricing_type, presence: true
  validates :name, uniqueness: { scope: :category_id, message: "Item name must be unique within category" }


  def self.ransackable_attributes(_auth_object = nil)
    %w[category_id created_at id is_disable name pricing_type updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["category"]
  end

  
  private
  def build_default_pricing
    Rails.logger.info "✅ Create ItemPricing для: #{name} (#{pricing_type})"

    new_pricing = item_pricings.build
    new_pricing.item = self 
    self.item_pricings << new_pricing 
  
    Rails.logger.info "✅ Create ItemPricing: #{new_pricing.inspect}"
  end

  def log_validation_errors
    if errors.any?
      Rails.logger.info "❌ Помилка валідації ITEM: #{errors.full_messages}"
    end
  
    item_pricings.each do |pricing|
      if pricing.errors.any?
        Rails.logger.info "❌ Помилка валідації ITEM_PRICING: #{pricing.errors.full_messages}"
      end
    end
  end
  
end
