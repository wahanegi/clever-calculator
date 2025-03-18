if AdminUser.count.zero?
  Rails.logger.info 'Creating Admin User'
  AdminUser.create!(email: ENV['ADMIN_USER_EMAIL'],
                    name: ENV['ADMIN_USER_NAME'],
                    password: ENV['ADMIN_USER_PASSWORD'],
                    password_confirmation: ENV['ADMIN_USER_PASSWORD'])
end
