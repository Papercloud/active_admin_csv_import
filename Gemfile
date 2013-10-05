source "https://rubygems.org"

# Declare your gem's dependencies in active_admin_csv_import.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'rails',  '3.2.13'
gem 'jquery-rails'
gem 'coffee-rails'

group :test do
  gem 'rspec-rails'
  gem 'activeadmin'

  # activeadmin dependencies
  gem 'sass-rails'
  gem 'sqlite3'
  gem "launchy", ">= 2.1.2"
  gem "database_cleaner", github: 'bmabey/database_cleaner', ref: '1ce7c9989acd4815621fe9a007fc4b759a37b239'
  gem "capybara", ">= 2.0.2"
  gem "poltergeist", "~> 1.3.0"
end
