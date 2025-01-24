source "https://rubygems.org"

ruby "3.4.1"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]

# A framework for creating elegant and customizable admin panels
gem "activeadmin", "~> 3.2", ">= 3.2.5"
# gem "bcrypt", "~> 3.1.7"
# Provides a front-end framework with responsive design, pre-styled components
gem "bootstrap", "~> 5.3", ">= 5.3.3"
# Sass compiler
gem "sassc", "~> 2.4"
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"
# Authentication
gem "devise", "~> 4.9", ">= 4.9.4"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"
# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.1"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]
# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"

group :development, :test do
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  # Loads environment variables from '.env'
  gem "dotenv"

  # Provides fixtures replacement for easier test object creation
  gem "factory_bot_rails"
  # Generates fake data for testing
  gem "faker"
  # Handles Cross-Origin Resource Sharing (CORS) for secure API requests
  gem "rack-cors"
  # Testing framework for Rails applications, providing tools for writing and running tests
  gem "rspec-rails"

  # Rubocop Ruby on Rails Style
  gem "rubocop"
  gem "rubocop-rails", require: false
  gem "rubocop-rspec_rails", require: false

  # Opens sent emails in the browser for easy debugging during development
  gem "letter_opener"
  # Provides simple and clean one-liner tests for Rails models, controllers, and other components.
  gem "shoulda-matchers"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end
