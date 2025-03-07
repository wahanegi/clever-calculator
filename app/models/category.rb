class Category < ApplicationRecord
  validates :name, presence: true,
                   uniqueness: { scope: :is_disabled,
                                 case_sensitive: false,
                                 conditions: -> { where(is_disabled: false) },
                                 message: "A category with this name already exists" }
end
