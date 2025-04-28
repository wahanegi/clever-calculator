class BrandColorBuilder
  def initialize(primary_color, secondary_color, blue_light, blue_sky)
    @primary_color = primary_color
    @secondary_color = secondary_color
    @blue_light = blue_light
    @blue_sky = blue_sky
  end

  def build_css
    [append_primary_color,
     append_secondary_color,
     append_blue_light_color,
     append_blue_sky_color].join("\n")
  end

  private

  def append_primary_color
    render_style('primary',
                 color_hex: @primary_color,
                 color_rgb: hex_to_rgb(@primary_color).join(', '))
  end

  def append_secondary_color
    render_style('secondary', color_hex: @secondary_color)
  end

  def append_blue_light_color
    render_style('blue_light', color_hex: @blue_light)
  end

  def append_blue_sky_color
    render_style('blue_sky', color_hex: @blue_sky)
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
