ActiveAdmin.register_page "Setting" do
  menu priority: 1

  content do
    setting = Setting.current

    active_admin_form_for setting, url: admin_setting_update_path,
                                   method: :put,
                                   html: { multipart: true } do |f|
      f.inputs do
        f.input :logo, as: :file
        f.input :style
      end
      f.actions do
        f.action :submit
      end
    end
  end

  page_action :update, method: :put do
    setting = Setting.current

    if setting.update(permitted_params)
      redirect_to admin_setting_path, notice: "Setting was successfully updated."
    else
      redirect_to admin_setting_path, alert: setting.errors.full_messages.to_sentence
    end
  end

  controller do
    def permitted_params
      params.require(:setting).permit(:style, :logo)
    end
  end
end
