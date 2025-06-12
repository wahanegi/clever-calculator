class SettingSerializer
  include JSONAPI::Serializer

  attribute :app_logo_icon do |setting|
    setting.app_logo_icon.attached? ? setting.app_logo_icon.url : nil
  end

  attribute :app_background_icon do |setting|
    setting.app_background_icon.attached? ? setting.app_background_icon.url : nil
  end
end
