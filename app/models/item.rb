class Item < ApplicationRecord
    belongs_to :category, optional: true

    enum :pricing_type, { fixed: 0, open: 1, fixed_open: 2 }

    validates :name, presence: true 
    validates :pricing_type, presence: true
    validates :name, uniqueness: { scope: :category_id, message: "Item name must be unique within category" }

    def self.ransackable_attributes(auth_object = nil)
        ["category_id", "created_at", "id", "is_disable", "name", "pricing_type", "updated_at"]
    end
    
    def self.ransackable_associations(auth_object = nil)
        ["category"]
    end
end
