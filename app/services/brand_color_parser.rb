class BrandColorParser
  HEX_REGEX = /\s*(?<color>#[0-9A-Fa-f]{3,6})/
  COLORS_COUNT = 5
  PATH_TO_SCSS = "app/assets/stylesheets/application/variables.scss".freeze

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

  def light_color
    get_color(/--bs-light: #{HEX_REGEX};/)
  end

  class << self
    def default_colors
      variables = fetch_variables

      colors = %w[primary secondary blue-light blue-sky light].map do |color_name|
        match_color = variables.match(/\$#{Regexp.escape(color_name)}:#{HEX_REGEX};/)

        match_color&.[](:color)
      end.compact_blank

      raise_if_colors_not_found colors

      colors
    end

    def fetch_variables
      File.read(Rails.root.join(PATH_TO_SCSS))
    end

    def raise_if_colors_not_found(colors)
      return if colors.size == COLORS_COUNT

      raise "Colors not found in #{PATH_TO_SCSS}"
    end
  end

  private

  def get_color(regex)
    color = @style.match(regex)

    color ? color[:color] : '#000000'
  end
end
