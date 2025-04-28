ActiveAdmin.register_page "Setting" do
  menu priority: 1

  content do
    render partial: 'admin/setting/display_logo', locals: { setting: setting }
    render partial: 'admin/setting/form', locals: { setting: setting,
                                                    style: BrandColorParser.new(setting.style) }
  end

  page_action :update, method: :put do
    if @setting.update(setting_params)
      redirect_to admin_setting_path, notice: "Setting was successfully updated."
    else
      redirect_to admin_setting_path, alert: @setting.errors.full_messages.to_sentence
    end
  end

  page_action :remove_logo, method: :delete do
    @setting.logo.purge

    redirect_to admin_setting_path, notice: 'Logo was successfully removed.'
  end

  page_action :reset, method: :patch do
    primary, secondary, blue_light, blue_sky = BrandColorParser.default_colors

    @setting.update(logo: nil, style: BrandColorBuilder.new(primary, secondary, blue_light, blue_sky).build_css)

    redirect_to admin_setting_path, notice: 'Settings reset successfully.'
  end

  controller do
    before_action :set_setting

    def permitted_params
      params.require(:setting).permit(:logo,
                                      :primary_color,
                                      :secondary_color,
                                      :blue_light_color,
                                      :blue_sky_color)
    end

    def setting_params
      hash = { style: BrandColorBuilder.new(permitted_params[:primary_color],
                                            permitted_params[:secondary_color],
                                            permitted_params[:blue_light_color],
                                            permitted_params[:blue_sky_color]).build_css }
      hash[:logo] = permitted_params[:logo] if permitted_params[:logo]
      hash
    end

    private

    def set_setting
      @setting = Setting.current
    end
  end
end
