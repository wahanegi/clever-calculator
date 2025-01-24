class Customer < ApplicationRecord
  validates :company_name, presence: true, uniqueness: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[address company_name created_at email first_name id last_name notes position
       updated_at]
  end
end
