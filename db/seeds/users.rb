if Rails.env.development?
  users_count = 10

  if User.count.zero?
    Rails.logger.info 'Creating users'
    users_count.times do |i|
      Rails.logger.info "Creating User: #{i}"
      User.create!(email: Faker::Internet.unique.email,
                   name: Faker::Name.name,
                   password: '1@password',
                   password_confirmation: '1@password')
    end
  end
end
