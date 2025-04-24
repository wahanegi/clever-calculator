module Api
  module V1
    class SettingsController < ApplicationController
      skip_before_action :authenticate_user!

      def show
        setting = Setting.current

        render json: SettingSerializer.new(setting).serializable_hash, status: :ok
      end
    end
  end
end
