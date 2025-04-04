class Customer < ApplicationRecord
  has_many :quotes, dependent: :destroy
  has_one_attached :logo

  validates :company_name, presence: true, uniqueness: { case_sensitive: false }
  validate :logo_size_and_type

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[address company_name created_at email first_name id last_name notes position
       updated_at]
  end

  private

  def logo_size_and_type
    return unless logo.attached?

    errors.add(:logo, 'must be less than 1 megabyte') if logo.byte_size > 1.megabyte

    return if %w[image/jpeg image/png].include?(logo.content_type)

    errors.add(:logo, 'must be a JPEG or PNG file')
  end
end
