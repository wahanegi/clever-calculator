class Quote < ApplicationRecord
  belongs_to :customer
  belongs_to :user
  has_many :quote_items, dependent: :destroy
  accepts_nested_attributes_for :quote_items, allow_destroy: true
  has_many :items, through: :quote_items
  has_many :quote_categories, dependent: :destroy
  has_many :categories, through: :quote_categories
  has_many :notes, dependent: :destroy

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum :step, { customer_info: 'customer_info', items_pricing: 'items_pricing', completed: 'completed' }

  scope :unfinished, -> { where.not(step: 'completed') }
  scope :completed, -> { where(step: 'completed') }

  def self.last_unfinished
    unfinished.order(created_at: :desc).first
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id customer_id user_id total_price created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[customer user]
  end

  def recalculate_total_price
    update(total_price: quote_items.sum(:final_price))
  end
end
