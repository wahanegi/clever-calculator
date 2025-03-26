if Rails.env.development?
  quotes_count = 10

  if Quote.count.zero?
    Rails.logger.info 'Creating quotes'
    customers = Customer.all
    users = User.all
    quotes_count.times do |i|
      Rails.logger.info "Creating Quote: #{i}"
      Quote.create!(total_price: Faker::Number.decimal,
                    step: %w[customer_info items_pricing completed].sample,
                    customer: customers.sample,
                    user: users.sample)
    end
  end
end
