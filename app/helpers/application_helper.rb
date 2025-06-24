module ApplicationHelper
  def admin_email
    AdminUser.find_by(administrator: true)&.email || AdminUser.order(:id).first&.email
  end
end
