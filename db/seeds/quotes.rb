if Rails.env.development?
  quotes_count = 2

  def quote_item_attributes(item)
    {
      item_id: item.id,
      price: 0,
      discount: 0,
      final_price: 0
    }
  end

  if Quote.count.zero?
    Rails.logger.info 'Creating quotes'
    customers = Customer.all
    users = User.all
    items = Item.all
    contract_types = ContractType.all

    quotes_count.times do |i|
      Rails.logger.info "Creating Quote: #{i}"
      quote = Quote.create!(total_price: 0,
                            step: %w[customer_info items_pricing completed].sample,
                            customer: customers.sample,
                            user: users.sample,
                            contract_type: contract_types.sample,
                            contract_start_date: Time.zone.today,
                            contract_end_date: Time.zone.today + 30.days)

      quote.quote_items.create!(items.map { |item| quote_item_attributes(item) })
    end
  end
end
