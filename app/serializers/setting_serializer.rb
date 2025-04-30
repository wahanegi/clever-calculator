class SettingSerializer
  include JSONAPI::Serializer

  attribute :logo do |setting|
    setting.logo.attached? ? setting.logo.url : nil
  end

  attribute :app_background do |setting|
    setting.app_background.attached? ? setting.app_background.url : nil
  end
end
