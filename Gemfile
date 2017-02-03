source 'https://rubygems.org'

## Core

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use puma as possible replacement for unicorn
gem 'puma'
# Use MySQL2 for production database
gem 'mysql2'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

## Assets

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Tether for use with bootstrap
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end
# Use bootstrap for styling
gem 'bootstrap', '~> 4.0.0.alpha5'
# Use font awesome for icons
gem 'font-awesome-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Chartkick for Rails generated graphs
gem 'chartkick'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Use dateslices for dating
gem 'dateslices'
# Use breadcrumbs_on_rails for page breadcrumbs
gem 'breadcrumbs_on_rails'
# Use redcarpet for Markdown Parser
gem 'redcarpet'
# Use markdownjs for markdown rendering
gem 'markdownjs-rails'
# Use countdown for home page count down
gem 'jquery-countdown-rails'
# Use countup for home page statistics
gem 'countupjs-rails', '~> 1.3', '>= 1.3.2.3'

## Models

# Validate email format without Regex
gem 'validates_email_format_of'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

## Controller

# Use respond_to in controller and respond_with
gem 'responders'

group :development, :test do
  ## Debugging

  # Call anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Replace rails default error pages
  gem 'better_errors', '~> 2.1.1'
  # Advanced features of better errors
  gem 'binding_of_caller', '~> 0.7.2'
  # Better printing of ruby objects
  gem 'awesome_print', '~> 1.7.0', require: 'ap'
  # View emails in dev environments
  gem 'letter_opener', '~> 1.4.1'

  ## Testing

  # Replace rails testing with rspec
  gem 'rspec-rails'
  # Create database objects during testing with ease
  gem 'factory_girl_rails'
  # Use FFaker for random value generation
  gem 'ffaker'
  # Use for Rspec tests
  gem 'database_cleaner'

  ## Refactoring

  # Use rubocop to check style
  gem 'rubocop', '~> 0.44.1', require: false
  # Check style for tests
  gem 'rubocop-rspec', require: false
  # Use bullet to find performace issues
  gem 'bullet', '~> 5.4.2'

  ## Security

  # Audit the gemfile for insecure gems
  gem 'bundler-audit', '~> 0.5.0', require: false
  # Scan the application for vulnerabilities
  gem 'brakeman', '~> 3.4.0', require: false
end

group :development do
  ## Utility

  # Watches the filesystem for changes
  gem 'listen', '~> 3.1.5'
  # Update spring using listen
  gem 'spring-watcher-listen', '~> 2.0.1'
  # Access an IRB console
  gem 'web-console', '~> 2.0'
  # Keep the application loaded in the background
  gem 'spring', '~> 2.0.0'
end
