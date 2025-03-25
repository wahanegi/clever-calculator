class Note < ApplicationRecord
  belongs_to :quote
  belongs_to :quote_item, optional: true
  belongs_to :category, optional: true

  validates :quote, presence: true
  validates :notes, presence: true
end
