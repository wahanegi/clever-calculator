class Category < ApplicationRecord
  validates :name, presence: true,
                   uniqueness: { scope: :is_disabled,
                                 case_sensitive: false,
                                 conditions: -> { where(is_disabled: false) },
                                 message: "A category with this name already exists" }
  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id id_value is_disabled name updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
