class Customer < ApplicationRecord
  has_many :quotes, dependent: :destroy
  has_one_attached :logo
  normalizes :company_name, with: ->(company_name) { company_name.gsub(/\s+/, ' ').strip }

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

    errors.add(:logo, 'must be less than 2 megabytes') if logo.byte_size > 2.megabytes

    return if %w[image/jpeg image/png].include?(logo.content_type)

    errors.add(:logo, 'must be a JPEG or PNG file')
  end
end
