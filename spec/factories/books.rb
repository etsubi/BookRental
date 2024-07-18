FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    isbn { Faker::Number.unique.number(digits: 10) }
    author { Faker::Book.author }
    available_copies { Faker::Number.between(from: 1, to: 100) }
  
    trait :without_available_copies do
      available_copies { nil }
    end
  end
end
