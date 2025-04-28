class BrandColorParser
  HEX_REGEX = /(#[0-9A-Fa-f]{3,6})/
  COLORS_COUNT = 4

  def initialize(style)
    @style = style
  end

  def primary_color
    get_color(/--bs-primary: #{HEX_REGEX};/)
  end

  def secondary_color
    get_color(/--bs-secondary: #{HEX_REGEX};/)
  end

  def blue_sky_color
    get_color(/.bg-blue-sky {
    background-color: #{HEX_REGEX};
}/)
  end

  def blue_light_color
    get_color(/.bg-blue-light {
    background-color: #{HEX_REGEX};
}/)
  end

  def self.default_colors
    style = File.read(Rails.root.join("app/assets/stylesheets/application/variables.scss"))

    primary = style.scan(/\$primary: #{HEX_REGEX};/)
    secondary = style.scan(/\$secondary: #{HEX_REGEX};/)
    blue_light = style.scan(/\$blue-light: #{HEX_REGEX};/)
    blue_sky = style.scan(/\$blue-sky: #{HEX_REGEX};/)

    colors = [primary, secondary, blue_light, blue_sky].flatten.compact

    unless colors.empty? || colors.size == COLORS_COUNT
      raise "Colors not found in app/assets/stylesheets/application/variables.scss"
    end

    colors
  end

  private

  def get_color(regex)
    color = @style.match(regex)

    color ? color[1] : '#000000'
  end
end
