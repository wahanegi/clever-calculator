class Customer < ApplicationRecord
  has_many :quotes, dependent: :destroy
  has_one_attached :logo

  normalizes :company_name, with: ->(company_name) { company_name.gsub(/\s+/, ' ').strip }

  validates :company_name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }
  validate :logo_size_and_type, if: -> { logo.attached? }

  MAX_LOGO_SIZE = 2.megabytes
  ALLOWED_LOGO_TYPES = %w[image/jpeg image/png].freeze
  LOGO_RESIZE_LIMIT = [280, 240].freeze

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def small_logo
    logo.variant(resize_to_limit: LOGO_RESIZE_LIMIT).processed
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[address company_name created_at email first_name id last_name notes position
       updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["quotes"]
  end

  private

  def logo_size_and_type
    errors.add(:logo, "must be less than #{MAX_LOGO_SIZE / 1.megabyte}MB") if logo.byte_size > MAX_LOGO_SIZE

    return if ALLOWED_LOGO_TYPES.include?(logo.content_type)

    errors.add(:logo, 'must be a JPEG or PNG file')
  end
end
