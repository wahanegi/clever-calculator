def load_seed_for(name)
  require_relative "../../../db/seeds/#{name}"
end

namespace :db do
  namespace :seed do
    desc "Load the seed data for the categories from db/seeds/categories.rb"
    task categories: :environment do
      load_seed_for 'categories'
    end

    desc "Load the seed data for the admin users from the db/seeds/admin_users.rb"
    task admin_users: :environment do
      load_seed_for 'admin_users'
    end

    desc "Load the seed data for the admin users from the db/seeds/customers.rb"
    task customers: :environment do
      load_seed_for 'customers'
    end
  end
end
