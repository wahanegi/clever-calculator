class Customer < ApplicationRecord
  has_many :quotes, dependent: :destroy
  validates :company_name, presence: true, uniqueness: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[address company_name created_at email first_name id last_name notes position
       updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ["quotes"]
  end
end
