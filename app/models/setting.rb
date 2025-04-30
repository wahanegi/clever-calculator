class Setting < ApplicationRecord
  has_one_attached :logo
  has_one_attached :login_background
  has_one_attached :app_background

  validate :only_one_setting_allowed
  validate :logo_size_and_type, if: -> { logo.attached? }
  validate :login_background_size_and_type, if: -> { login_background.attached? }
  validate :app_background_size_and_type, if: -> { app_background.attached? }

  MAX_LOGO_SIZE = 1.megabyte
  ALLOWED_LOGO_TYPES = %w[image/jpeg image/png image/svg+xml].freeze

  # Returns the singleton setting instance, creates it if it doesn't exist
  def self.current
    return first if exists?

    # fetch colors from SCSS file
    primary, secondary, blue_light, blue_sky = BrandColorParser.default_colors

    # build style
    style = BrandColorBuilder.new(primary, secondary, blue_light, blue_sky).build_css

    create!(style: style)
  end

  private

  def only_one_setting_allowed
    return unless Setting.where.not(id: id).exists?

    errors.add(:base, "Only one setting instance is allowed.")
  end

  def logo_size_and_type
    errors.add(:logo, "must be less than #{MAX_LOGO_SIZE / 1.megabyte}MB") if logo.byte_size > MAX_LOGO_SIZE

    return if ALLOWED_LOGO_TYPES.include?(logo.content_type)

    errors.add(:logo, 'must be a JPEG, SVG or PNG file')
  end

  def login_background_size_and_type
    if login_background.byte_size > MAX_LOGO_SIZE
      errors.add(:login_background,
                 "must be less than #{MAX_LOGO_SIZE / 1.megabyte}MB")
    end

    return if ALLOWED_LOGO_TYPES.include?(login_background.content_type)

    errors.add(:login_background, 'must be a JPEG, SVG or PNG file')
  end

  def app_background_size_and_type
    if app_background.byte_size > MAX_LOGO_SIZE
      errors.add(:app_background,
                 "must be less than #{MAX_LOGO_SIZE / 1.megabyte}MB")
    end

    return if ALLOWED_LOGO_TYPES.include?(app_background.content_type)

    errors.add(:app_background, 'must be a JPEG, SVG or PNG file')
  end
end
