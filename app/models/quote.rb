class Quote < ApplicationRecord
  belongs_to :customer
  belongs_to :user

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :customer_name, ->(search = nil) {
    return all if search.blank?

    search = "%#{sanitize_sql_like(search.to_s.downcase)}%"
    joins(:customer).where('LOWER(customers.first_name) LIKE :search OR LOWER(customers.last_name) LIKE :search', search: "%#{search}%")
  }

  def self.ransackable_attributes(_auth_object = nil)
    %w[id customer_id user_id total_price created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ["customer", "user"]
  end

  def self.ransackable_scopes(auth_object = nil)
    [:customer_name]
  end
end
