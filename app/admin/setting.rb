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
    image_attribute = params[:type]
    allowed_attributes = %w[app_logo_icon app_background_icon word_header_document_logo]

    if allowed_attributes.include?(image_attribute)
      @setting.public_send(image_attribute).purge

      redirect_to admin_setting_path, notice: "#{image_attribute.humanize} was successfully removed."
    else
      redirect_to admin_setting_path, alert: 'Unknown or missing image type.'
    end
  end

  page_action :reset, method: :patch do
    default_colors = BrandColorParser.default_colors

    @setting.update(app_logo_icon: nil,
                    app_background_icon: nil,
                    word_header_document_logo: nil,
                    style: BrandColorBuilder.new(*default_colors).build_css)

    redirect_to admin_setting_path, notice: 'Settings reset successfully.'
  end

  controller do
    before_action :set_setting

    def setting_params
      # Build the style CSS from color params
      params_hash = { style: BrandColorBuilder.new(*selected_color_params).build_css }

      # Attach optional uploaded files if present
      %i[app_logo_icon app_background_icon word_header_document_logo].each do |key|
        params_hash[key] = permitted_setting_params[key] if permitted_setting_params[key].present?
      end

      params_hash
    end

    private

    def set_setting
      @setting = Setting.current
    end

    def selected_color_params
      permitted_setting_params.values_at(:primary_color,
                                         :secondary_color,
                                         :blue_light_color,
                                         :blue_sky_color,
                                         :light_color)
    end

    def permitted_setting_params
      params.require(:setting).permit(:app_logo_icon,
                                      :app_background_icon,
                                      :word_header_document_logo,
                                      :primary_color,
                                      :secondary_color,
                                      :blue_light_color,
                                      :blue_sky_color,
                                      :light_color)
    end
  end
end
