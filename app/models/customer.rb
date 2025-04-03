class Customer < ApplicationRecord
  has_many :quotes, dependent: :destroy
  has_one_attached :logo

  validates :company_name, presence: true, uniqueness: { case_sensitive: false }
  validate :logo_size, if: -> { logo.attached? }
  validate :logo_type, if: -> { logo.attached? }

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[address company_name created_at email first_name id last_name notes position
       updated_at]
  end

  private

  def logo_size
    errors.add(:logo, "should be less than 1MB") if logo.blob.byte_size > 1.megabytes
  end

  def logo_type
    errors.add(:logo, "must be a .JPEG or .PNG") unless logo.content_type.in?(%w[image/jpeg image/png])
  end
end
