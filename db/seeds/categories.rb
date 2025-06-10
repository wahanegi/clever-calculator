if Rails.env.development?
  disabled_count = 2
  enabled_count = 1

  def create_category!(is_disabled)
    name = Faker::Team.unique.name
    description = Faker::Food.description

    Rails.logger.info "Creating Category: #{name}"
    Category.create!(name: name,
                     description: description,
                     is_disabled: is_disabled)
  end

  if Category.count.zero?
    Rails.logger.info 'Creating disable categories'
    disabled_count.times do
      create_category! false
    end

    Rails.logger.info 'Creating enable categories'
    enabled_count.times do
      create_category! true
    end
  end
end
