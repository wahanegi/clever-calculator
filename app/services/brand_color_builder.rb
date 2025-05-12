class BrandColorBuilder
  def initialize(primary, secondary, blue_light, blue_sky, light)
    @primary = primary
    @secondary = secondary
    @blue_light = blue_light
    @blue_sky = blue_sky
    @light = light
  end

  def build_css
    styles = []

    styles << append_primary_color if @primary
    styles << append_secondary_color if @secondary
    styles << append_blue_light_color if @blue_light
    styles << append_blue_sky_color if @blue_sky
    styles << append_light_color if @light

    styles.join("\n")
  end

  private

  def append_primary_color
    render_style('primary', color_hex: @primary, color_rgb: hex_to_rgb(@primary).join(', '))
  end

  def append_secondary_color
    render_style('secondary', color_hex: @secondary)
  end

  def append_blue_light_color
    render_style('blue_light', color_hex: @blue_light)
  end

  def append_blue_sky_color
    render_style('blue_sky', color_hex: @blue_sky)
  end

  def append_light_color
    render_style('light', color_hex: @light, color_rgb: hex_to_rgb(@light).join(', '))
  end

  def render_style(name, **locals)
    ApplicationController.render(partial: "admin/setting/styles/#{name}",
                                 formats: :css,
                                 template: false, locals: locals)
  end

  def hex_to_rgb(hex)
    return [0, 0, 0] unless hex

    hex = hex.delete("#")

    red = hex[0..1].to_i(16)
    green = hex[2..3].to_i(16)
    blue = hex[4..5].to_i(16)

    [red, green, blue]
  end
end
