FactoryBot.define do
  factory :client do
    sequence(:name) { |n| "client-sa-#{n}" }
    role { 1 }

    trait :admin do
      sequence(:name) { |n| "admin-sa-#{n}" }
      role { 0 }
    end
  end
end
