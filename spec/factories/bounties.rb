FactoryBot.define do
  factory :bounty do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    company_name { Faker::Company.name }
    user

    trait :pending do
      status { 'pending' }
    end

    trait :rejected do
      status { 'rejected' }
    end

    trait :approved do
      status { 'approved' }
    end

    factory :pending_bounty, traits: [:pending]
    factory :rejected_bounty, traits: [:rejected]
    factory :approved_bounty, traits: [:approved]
  end
end
