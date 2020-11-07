FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }

    trait :moderator do
      moderator { true }
    end

    factory :moderator, traits: [:moderator]
  end
end
