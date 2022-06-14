require 'faker'

FactoryBot.define do
  factory :user do
    first_name { 'Jake' }
    last_name { 'Pop' }
    password { '12345678' }
    email { Faker::Internet.email }
    confirmed_at { Time.now.utc }
  end
end
