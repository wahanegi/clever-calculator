source "https://rubygems.org"

ruby "3.4.1"

gem "activeadmin", "~> 3.3.0"                                       # A framework for creating elegant and customizable admin panels
# gem "bcrypt", "~> 3.1"                                            # Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bootsnap", '~> 1.18.6', require: false                         # Reduces boot times through caching; required in config/boot.rb
gem "caracal", "~> 1.4"                                             # Caracal is a ruby library for dynamically creating professional-quality Microsoft Word documents (.docx).
gem "cssbundling-rails", '~> 1.4.3'                                 # Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem 'dentaku', "~> 3.5.4"                                           # Evaluator for a mathematical and logical formulas
gem "devise", "~> 4.9.4"                                            # Authentication
gem "image_processing", "~> 1.2"                                    # Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "jbuilder", '~> 2.13.0'                                         # Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jsbundling-rails", '~> 1.3.1'                                  # Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsonapi-serializer", "~> 2.2.0"                                # Fast, simple and easy to use JSON:API serialization library (also known as fast_jsonapi).
gem "kamal", '~> 2.7.0', require: false                             # Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "pg", "~> 1.5.9"                                                # Use postgresql as the database for Active Record
gem "puma", "~> 6.6.0"                                              # Use the Puma web server [https://github.com/puma/puma]
gem "rails", "~> 8.0.2"                                             # Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "ruby-vips", "~> 2.2"                                           # Ruby extension for the libvips image processing library.
gem 'sass-rails', '~> 6.0.0'                                        # Ruby on Rails stylesheet engine for Sass
gem "solid_cable", '~> 3.0.11'                                      # Use the database-backed adapters for Action Cable
gem "solid_cache", '~> 1.0.7'                                       # Use the database-backed adapters for Rails.cache
gem "solid_queue", '~> 1.1.5'                                       # Use the database-backed adapters for Active Job
gem "sprockets", '~> 3.7.5', '< 4.0'                                # Rack-based asset packaging system
gem "sprockets-rails", '~> 3.5.2'                                   # The asset pipeline for Rails
gem "stimulus-rails", '~> 1.3.4'                                    # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "thruster", '~> 0.1.14', require: false                         # Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "turbo-rails", '~> 2.0.16'                                      # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "tzinfo-data", '~> 1.2025.2', platforms: %i[ windows jruby ]    # Windows does not include zoneinfo files, so bundle the tzinfo-data gem

group :development, :test do
  gem "brakeman", require: false                                         # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"    # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "docx", "~> 0.3.0"                                                 # a ruby library/gem for interacting with .docx files [https://github.com/ruby-docx/docx]
  gem "dotenv"                                                           # Loads environment variables from '.env'
  gem "factory_bot_rails"                                                # Provides fixtures replacement for easier test object creation
  gem "faker"                                                            # Generates fake data for testing
  gem "letter_opener"                                                    # Opens sent emails in the browser for easy debugging during development
  gem "rack-cors"                                                        # Handles Cross-Origin Resource Sharing (CORS) for secure API requests
  gem "rspec-rails"                                                      # Testing framework for Rails applications, providing tools for writing and running tests
  gem "rubocop", require: false                                          # A Ruby static code analyzer and formatter, based on the community Ruby style guide.
  gem "rubocop-rails", require: false                                    # A Rubocop extension focused on enforcing Rails best practices and coding conventions.
  gem "rubocop-rspec_rails", require: false                              # A Rubocop extension focused code style checking for Rails-related RSpec files.
  gem "shoulda-matchers"                                                 # Provides simple and clean one-liner tests for Rails models, controllers, and other components.
end

group :development do
  gem "web-console"                                # Use console on exceptions pages [https://github.com/rails/web-console]
end

group :production do
  gem "aws-sdk-s3", '~> 1.196.0'                   # AWS SDK for Ruby
end
