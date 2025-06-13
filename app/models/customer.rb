class Customer < ApplicationRecord
  has_many :quotes, dependent: :destroy
  has_one_attached :logo

  MAX_LOGO_SIZE = 2.megabytes
  ALLOWED_LOGO_TYPES = %w[image/jpeg image/png].freeze
  LOGO_RESIZE_LIMIT = [280, 240].freeze

  normalizes :company_name, with: ->(company_name) { company_name.gsub(/\s+/, ' ').strip }

  validates :company_name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email format" },
                    if: -> { email.present? }
  validates :logo, file_size: { max: MAX_LOGO_SIZE },
                   file_content_type: { allowed_types: ALLOWED_LOGO_TYPES },
                   if: -> { logo.attached? }

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
end
