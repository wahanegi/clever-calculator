class ContractType < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name updated_at]
  end
end
