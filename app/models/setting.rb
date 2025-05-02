class Setting < ApplicationRecord
  has_one_attached :logo
  has_one_attached :login_background
  has_one_attached :app_background

  MAX_IMAGE_SIZE = 1.megabyte
  ALLOWED_IMAGE_TYPES = %w[image/jpeg image/png image/svg+xml].freeze

  validate :only_one_setting_allowed
  validates :logo, file_size: { max: MAX_IMAGE_SIZE },
                   file_content_type: { allowed_types: ALLOWED_IMAGE_TYPES,
                                        message: 'must be a JPEG, SVG or PNG file' },
                   if: -> { logo.attached? }
  validates :app_background, file_size: { max: MAX_IMAGE_SIZE },
                             file_content_type: { allowed_types: ALLOWED_IMAGE_TYPES,
                                                  message: 'must be a JPEG, SVG or PNG file' },
                             if: -> { app_background.attached? }
  validates :login_background, file_size: { max: MAX_IMAGE_SIZE },
                               file_content_type: { allowed_types: ALLOWED_IMAGE_TYPES,
                                                    message: 'must be a JPEG, SVG or PNG file' },
                               if: -> { login_background.attached? }

  # Returns the singleton setting instance, creates it if it doesn't exist
  def self.current
    return first if exists?

    # fetch colors from SCSS file
    primary, secondary, blue_light, blue_sky, light = BrandColorParser.default_colors

    # build style
    style = BrandColorBuilder.new(primary, secondary, blue_light, blue_sky, light).build_css

    create!(style: style)
  end

  private

  def only_one_setting_allowed
    return unless Setting.where.not(id: id).exists?

    errors.add(:base, "Only one instance of Setting is allowed.")
  end
end
