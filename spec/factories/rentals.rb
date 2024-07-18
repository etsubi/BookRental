FactoryBot.define do
  factory :rental do
    user 
    book 
    rented_on {DateTime.now}
    returned_on { nil }
    
    trait :returned do
      returned_on { DateTime.now + 7.days }
    end
  end
end
