source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# api
gem 'grape', '~> 1.2', '>= 1.2.5'
gem 'grape-route-helpers', '~> 2.1'
gem 'grape-entity', '~> 0.7.1'
gem 'grape-swagger', '~> 0.34.2'
gem 'grape-swagger-entity', '~> 0.3.4'
gem 'grape-swagger-rails', '~> 0.3.1'
gem 'grape_logging', '~> 1.8', '>= 1.8.3'
gem 'rack-cors', :require => 'rack/cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'annotate', '~> 3.1', '>= 3.1.1'
  gem 'pry-rails', '~> 0.3.9'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end
source 'https://gems.tanmer.com' do
  gem 'tmdomain-notifications', '0.5.4'
  gem 'tmlib-extensions', '0.1.3'
  gem 'tmlib-acts_as_status', '0.1.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'faraday', '~> 1.1'
gem 'figaro', '~> 1.2'
gem 'jpush', '~> 4.0', '>= 4.0.11'
gem 'kaminari', '~> 1.2', '>= 1.2.1'
gem 'sidekiq', '~> 6.1', '>= 6.1.2'
