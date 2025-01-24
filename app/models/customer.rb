class Customer < ApplicationRecord
  validates :company_name, presence: true, uniqueness: true
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :address, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :position, presence: true
  validates :notes, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[address company_name created_at email first_name id last_name notes position
       updated_at]
  end
end
