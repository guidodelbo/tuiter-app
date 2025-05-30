source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.2'

gem 'active_storage_validations', '0.8.9'
gem 'bcrypt', '~> 3.1.13'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false
gem 'bootstrap-sass', '~> 3.4.1'
gem 'bootstrap-will_paginate', '1.0.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'faker', '~> 3.4', '>= 3.4.2'
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'
gem 'jbuilder'
# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem 'kamal', require: false
gem 'mailgun-ruby', '~>1.2.16'
gem 'mini_magick', '4.11.0'
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'pg', '~> 1.4'
gem 'propshaft'
gem 'puma', '~> 6.6'
gem 'rails', '~> 8.0.1'
gem 'sass-rails', '~> 6'
# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'
# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', require: false
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
gem 'will_paginate', '3.3.0'

group :development, :test do
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 7.0.0'
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem 'rubocop-rails-omakase', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
  gem 'ruby-lsp-rspec', require: false
end

group :development do
  gem 'letter_opener'
  gem 'listen', '~> 3.3'

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'guard', '>= 2.16.2'
  gem 'guard-minitest', '>= 2.4.6'
  gem 'minitest', '>= 5.11.3'
  gem 'minitest-reporters', '>= 1.3.8'
  gem 'rails-controller-testing', '>= 1.0.5'
  gem 'selenium-webdriver', '>= 4.11'
end

group :production do
  gem 'aws-sdk-s3', '~> 1.131.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
