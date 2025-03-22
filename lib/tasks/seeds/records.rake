def load_seed_for(name)
  seed_path = File.expand_path("../../../db/seeds/#{name}.rb", __dir__)

  if File.exist? seed_path
    require_relative seed_path
    puts "Successfully loaded seed: #{name}"
  else
    puts "Seed file not found: #{name}"
  end
end

namespace :db do
  namespace :seed do
    %w[categories admin_users customers].each do |name|
      desc "Load the seed data for the #{name} from db/seeds/#{name}.rb"
      task name.to_sym => :environment do
        load_seed_for name
      end
    end
  end
end
