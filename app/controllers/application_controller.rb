class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :authenticate_user!, unless: :active_admin_controller?
  before_action :set_active_storage_url_options

  private

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
  end

  def set_active_storage_url_options
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
  end
end
