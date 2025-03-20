# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if AdminUser.count.zero?
  Rails.logger.info 'Creating Admin User'
  AdminUser.create!(email: ENV.fetch('ADMIN_USER_EMAIL'),
                    name: ENV.fetch('ADMIN_USER_NAME'),
                    password: ENV.fetch('ADMIN_USER_PASSWORD'),
                    password_confirmation: ENV.fetch('ADMIN_USER_PASSWORD'))
end

if Rails.env.development?
  customers_count = 10

  if Customer.count.zero?
    Rails.logger.info 'Creating customers'
    customers_count.times do
      Customer.create!(company_name: Faker::Company.unique.name,
                       email: Faker::Internet.email,
                       first_name: Faker::Name.first_name,
                       last_name: Faker::Name.last_name,
                       position: Faker::Job.title,
                       address: Faker::Address.full_address,
                       notes: Faker::Lorem.sentence)
    end
  end

  if User.count.zero?
    Rails.logger.info 'Creating User'
    User.create!(name: 'Bob',
                 email: 'test@example.com',
                 password: ENV.fetch('USER_PASSWORD'),
                 password_confirmation: ENV.fetch('USER_PASSWORD'))
  end
end
