FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
  end

  factory :moderator do
    email { Faker::Internet.email }
    password { 'password' }
    moderator { true }
  end
end
