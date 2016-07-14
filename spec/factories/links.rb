FactoryGirl.define do
  factory :link do
    url { Faker::Internet.url }
    shortcode { Faker::Lorem.characters(6) }
    created_at { Faker::Time.between(Time.zone.now - 5.days, Time.zone.now - 1.day) }
    updated_at { created_at }

    trait :with_redirects do
      redirects { rand(10..50) }
      updated_at { Time.zone.now }
    end
  end
end
