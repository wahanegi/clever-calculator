class Setting < ApplicationRecord
  has_one_attached :app_logo_icon
  has_one_attached :app_background_icon
  has_one_attached :word_header_document_logo

  MAX_IMAGE_SIZE = 1.megabyte
  ALLOWED_IMAGE_TYPES = %w[image/jpeg image/png].freeze

  validate :only_one_setting_allowed
  validates :app_logo_icon, file_size: { max: MAX_IMAGE_SIZE },
                            file_content_type: { allowed_types: ALLOWED_IMAGE_TYPES },
                            if: -> { app_logo_icon.attached? }
  validates :app_background_icon, file_size: { max: MAX_IMAGE_SIZE },
                                  file_content_type: { allowed_types: ALLOWED_IMAGE_TYPES },
                                  if: -> { app_background_icon.attached? }
  validates :word_header_document_logo, file_size: { max: MAX_IMAGE_SIZE },
                                        file_content_type: { allowed_types: ALLOWED_IMAGE_TYPES },
                                        if: -> { word_header_document_logo.attached? }

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
