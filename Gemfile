# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'
gem 'faker', '~> 2.21'
gem 'devise', '~> 4.8'
gem 'bootstrap', '~> 5.1', '>= 5.1.3'
gem 'dotenv-rails', '~> 2.7.6', groups: %i[development test]
gem 'overcommit', '~> 0.59.1'
gem 'rubocop', '~> 1.30', require: false
gem 'rubocop-rails', '~> 2.14.2', require: false
gem 'rails', '~> 7.0.3'
gem 'sprockets-rails'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'bootsnap', require: false
gem 'rails-patterns'
gem 'pundit', '~> 2.2', require: true
gem 'ransack', '~> 3.2'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '~> 6.0.0.rc1'
  gem 'rails-controller-testing'
  gem 'factory_bot_rails', '~> 6.2'
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
