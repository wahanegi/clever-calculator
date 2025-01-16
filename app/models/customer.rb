class Customer < ApplicationRecord
  validates :company_name, presence: true, uniqueness: true
  validates :email, presence: true
  validates :address, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :position, presence: true
end
