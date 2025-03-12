if Rails.env.development?
  disabled_count = 10
  enabled_count = 5

  def random_name_and_description
    name = Faker::Team.unique.name
    description = Faker::Food.description
    [name, description]
  end

  def create_category!(is_disabled)
    name, description = random_name_and_description

    Rails.logger.info "Creating category: #{name}"
    Category.create!(name: name,
                     description: description,
                     is_disabled: is_disabled)
  end

  Rails.logger.info 'Creating disable categories'
  disabled_count.times do
    create_category! false
  end

  Rails.logger.info 'Creating enable categories'
  enabled_count.times do
    create_category! true
  end
end
