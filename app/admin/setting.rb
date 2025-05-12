ActiveAdmin.register_page "Setting" do
  menu priority: 1

  content do
    render partial: 'admin/setting/display_images', locals: { setting: setting }
    render partial: 'admin/setting/form', locals: { setting: setting,
                                                    style: BrandColorParser.new(setting.style) }
  end

  page_action :update, method: :put do
    if @setting.update(setting_params)
      redirect_to admin_setting_path, notice: "Setting was successfully updated."
    else
      render :index
    end
  end

  page_action :remove_image, method: :delete do
    case params[:type]
    when 'logo'
      @setting.logo.purge
    when 'login_background'
      @setting.login_background.purge
    when 'app_background'
      @setting.app_background.purge
    else
      redirect_to admin_setting_path, alert: 'Unknown or missing image type'
      return
    end

    redirect_to admin_setting_path, notice: "#{params[:type].humanize} was successfully removed."
  end

  page_action :reset, method: :patch do
    primary, secondary, blue_light, blue_sky, light = BrandColorParser.default_colors

    @setting.update(logo: nil,
                    app_background: nil,
                    login_background: nil,
                    style: BrandColorBuilder.new(primary, secondary, blue_light, blue_sky, light).build_css)

    redirect_to admin_setting_path, notice: 'Settings reset successfully.'
  end

  controller do
    before_action :set_setting

    def permitted_params
      params.require(:setting).permit(:logo,
                                      :login_background,
                                      :app_background,
                                      :primary_color,
                                      :secondary_color,
                                      :blue_light_color,
                                      :blue_sky_color,
                                      :light_color)
    end

    def setting_params
      hash = { style: BrandColorBuilder.new(permitted_params[:primary_color],
                                            permitted_params[:secondary_color],
                                            permitted_params[:blue_light_color],
                                            permitted_params[:blue_sky_color],
                                            permitted_params[:light_color]).build_css }
      hash[:logo] = permitted_params[:logo] if permitted_params[:logo]
      hash[:app_background] = permitted_params[:app_background] if permitted_params[:app_background]
      hash[:login_background] = permitted_params[:login_background] if permitted_params[:login_background]
      hash
    end

    private

    def set_setting
      @setting = Setting.current
    end
  end
end
