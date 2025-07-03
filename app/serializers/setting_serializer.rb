class SettingSerializer
  include JSONAPI::Serializer

  attribute :logo_light_background do |setting|
    setting.logo_light_background.attached? ? setting.logo_light_background.url : nil
  end

  attribute :logo_dark_background do |setting|
    setting.logo_dark_background.attached? ? setting.logo_dark_background.url : nil
  end
end
