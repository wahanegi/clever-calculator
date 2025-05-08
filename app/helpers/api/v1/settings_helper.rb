module Api
  module V1
    module SettingsHelper
      def current_setting
        Setting.current
      end
    end
  end
end
