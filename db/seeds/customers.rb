if Rails.env.development?
  customers_count = 10

  if Customer.count.zero?
    Rails.logger.info 'Creating customers'
    customers_count.times do
      Rails.logger.info 'Creating Customer'
      Customer.create!(company_name: Faker::Company.unique.name,
                       email: Faker::Internet.email,
                       first_name: Faker::Name.first_name,
                       last_name: Faker::Name.last_name,
                       position: Faker::Job.title,
                       address: Faker::Address.full_address,
                       notes: Faker::Lorem.sentence)
    end
  end
end
