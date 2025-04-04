# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

group :development, :test do
  gem 'database_cleaner-sequel', '~> 1.8'
  gem 'debug'
  gem 'factory_bot', '~> 6.1'
  gem 'rspec', '~> 3.10'
  gem 'rspec_junit_formatter', require: false # required for gitlab CI
  gem 'rubocop', '~> 1.9'
  gem 'rubocop-rspec', require: false
  gem 'webmock', '~> 3.11'
end

group :test do
  gem 'rack-test'
  gem 'simplecov', '0.21.2', require: false
end
