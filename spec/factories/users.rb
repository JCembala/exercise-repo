FactoryBot.define do
  factory :user do
    first_name { 'Jake' }
    last_name { 'Pop' }
    password { '12345678' }
    email { "#{first_name}.#{last_name}@example.com".downcase }
    confirmed_at { Time.now.utc }
  end
end
