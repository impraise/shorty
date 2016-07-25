FactoryGirl.define do
  factory :url_address do
    url { Faker::Internet.url }
  end
end
