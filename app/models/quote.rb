class Quote < ApplicationRecord
  belongs_to :customer
  belongs_to :user

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
