class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!, unless: :active_admin_controller?

  private

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
  end
end
