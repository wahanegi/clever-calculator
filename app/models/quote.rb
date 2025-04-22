class Quote < ApplicationRecord
  belongs_to :customer
  belongs_to :user

  validates :customer_id, presence: true 
  validates :user_id, presence: true 
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum :step, { customer_info: 'customer_info', items_pricing: 'items_pricing', completed: 'completed' }

  scope :unfinished, -> { where.not(step: 'completed') }
  scope :completed, -> { where(step: 'completed') }

  def self.last_unfinished
    unfinished.order(created_at: :desc).first
  end
end
