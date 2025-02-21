# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem 'us_core_test_kit'

group :development, :test do
  gem 'debug'
  gem 'rspec_junit_formatter', require: false  # required for gitlab CI
end

group :test do
  gem 'rack-test'
end
