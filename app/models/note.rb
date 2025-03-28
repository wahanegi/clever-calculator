class Note < ApplicationRecord
  belongs_to :quote
  belongs_to :quote_item, optional: true

  validates :quote, presence: true
  validates :notes, presence: true

  def self.ransackable_associations(_auth_object = nil)
    %w[quote quote_item]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id id_value is_printable notes quote_id quote_item_id updated_at]
  end
end
