class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!, unless: :active_admin_controller?
  before_action :set_current_url

  private

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
  end

  def set_current_url
    ActiveStorage::Current.url_options = { host: request.host_with_port }
  end
end
