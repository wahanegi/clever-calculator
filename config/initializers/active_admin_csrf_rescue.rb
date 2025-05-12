ActiveSupport.on_load(:after_initialize) do
  ActiveAdmin::BaseController.class_eval do
    rescue_from ActionController::InvalidAuthenticityToken, with: :handle_admin_csrf_error

    private

    def handle_admin_csrf_error
      redirect_to new_admin_user_session_path, alert: "Your session has expired. Please sign in again."
    end
  end
end
