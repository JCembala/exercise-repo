# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'
gem 'devise', '~> 4.8'
gem 'bootstrap', '~> 5.2'
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
gem 'kaminari', '~> 1.2.2'
gem 'lockbox', '~> 1.0.0'
gem 'blind_index', '~> 2.2'
gem 'sidekiq', '~> 6.5', '>= 6.5.6'
gem 'draper', '~> 4.0', '>= 4.0.2'
gem 'aasm', '~> 5.4.0'
gem 'omniauth', '~> 2.1'
gem 'omniauth-google-oauth2', '~> 1.1', '>= 1.1.1'

group :development, :test do
  gem 'dotenv-rails', '~> 2.7.6'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '~> 6.0.0.rc1'
  gem 'rails-controller-testing'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 2.21'
end

group :development do
  gem 'web-console'
  gem 'rubocop', '~> 1.35', require: false
  gem 'rubocop-rails', '~> 2.15.2', require: false
  gem 'overcommit', '~> 0.59.1'
  gem 'htmlbeautifier', '~> 1.3', '>= 1.3.1'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'simplecov', require: false
end
