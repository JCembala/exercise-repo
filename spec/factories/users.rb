require 'faker'

FactoryBot.define do
  factory :user do
    first_name { 'Jake' }
    last_name { 'Pop' }
    password { '12345678' }
    email { Faker::Internet.email }
    confirmed_at { Time.now.utc }

    trait :archived do
      archived_at { Time.now.utc }
    end

    trait :admin do
      admin { true }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :with_attached_file do
      after(:build) do |user|
        user.feed_exports.attach(
          io: File.open(Rails.root.join('spec/fixtures/feed_test.csv')),
          filename: 'feed_test.csv',
          content_type: 'text/csv'
        )
      end
    end
  end
end
