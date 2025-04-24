class SettingSerializer
  include JSONAPI::Serializer

  attribute :logo do |setting|
    setting.logo.attached? ? setting.logo.url : nil
  end
end
