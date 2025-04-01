source "https://rubygems.org"

ruby "3.4.1"

gem "activeadmin", "~> 3.2", ">= 3.2.5"           # A framework for creating elegant and customizable admin panels
gem "aws-sdk-s3", require: false                  # AWS SDK for Ruby
# gem "bcrypt", "~> 3.1.7"                        # Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bootsnap", require: false                    # Reduces boot times through caching; required in config/boot.rb
gem "cssbundling-rails"                           # Bundle and process CSS [https://github.com/rails/cssbundling-rails]
# gem "image_processing", "~> 1.2"                # Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "devise", "~> 4.9", ">= 4.9.4"                # Authentication
gem "jbuilder"                                    # Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jsbundling-rails"                            # Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsonapi-serializer", "~> 2.2"                # Fast, simple and easy to use JSON:API serialization library (also known as fast_jsonapi).
gem "kamal", require: false                       # Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "pg", "~> 1.1"                                # Use postgresql as the database for Active Record
gem "puma", ">= 5.0"                              # Use the Puma web server [https://github.com/puma/puma]
gem "rails", "~> 8.0.1"                           # Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'sass-rails', '~> 6'                          # Ruby on Rails stylesheet engine for Sass
gem "solid_cable"                                 # Use the database-backed adapters for Action Cable
gem "solid_cache"                                 # Use the database-backed adapters for Rails.cache
gem "solid_queue"                                 # Use the database-backed adapters for Active Job
gem "sprockets-rails"                             # The asset pipeline for Rails
gem "stimulus-rails"                              # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "thruster", require: false                    # Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "turbo-rails"                                 # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "tzinfo-data", platforms: %i[ windows jruby ] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem

group :development, :test do
  gem "brakeman", require: false                                      # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude" # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "dotenv"                                                        # Loads environment variables from '.env'
  gem "factory_bot_rails"                                             # Provides fixtures replacement for easier test object creation
  gem "faker"                                                         # Generates fake data for testing
  gem "letter_opener"                                                 # Opens sent emails in the browser for easy debugging during development
  gem "rack-cors"                                                     # Handles Cross-Origin Resource Sharing (CORS) for secure API requests
  gem "rspec-rails"                                                   # Testing framework for Rails applications, providing tools for writing and running tests
  gem "rubocop"                                                       # Rubocop Ruby on Rails Style
  gem "rubocop-rails", require: false                                 # A Rubocop extension focused on enforcing Rails best practices and coding conventions.
  gem "rubocop-rspec_rails", require: false                           # A Rubocop extension focused code style checking for Rails-related RSpec files.
  gem "shoulda-matchers"                                              # Provides simple and clean one-liner tests for Rails models, controllers, and other components.
end

group :development do
  gem "web-console"                               # Use console on exceptions pages [https://github.com/rails/web-console]
end
