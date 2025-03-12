class Category < ApplicationRecord
  has_many :items, dependent: :destroy

  after_update :update_items_status, if: :is_disabled_changed?

  validates :name, presence: true,
                   uniqueness: { scope: :is_disabled,
                                 case_sensitive: false,
                                 conditions: -> { where(is_disabled: false) },
                                 message: "A category with this name already exists" }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id id_value is_disabled name updated_at]
  end

  private

  def update_items_status
    # rubocop:disable Rails/SkipsModelValidations
    items.update_all(is_disabled: is_disabled)
    # rubocop:enable Rails/SkipsModelValidations
  end
end
