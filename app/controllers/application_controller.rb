class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :authenticate_user!, unless: :active_admin_controller?
  before_action :set_active_storage_url_options

  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_user_csrf_error

  private

  def handle_user_csrf_error
    redirect_to new_user_session_path, alert: "Your session has expired. Please sign in again."
  end

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
  end

  def set_active_storage_url_options
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
  end
end
