FactoryBot.define do
  factory :short_link do
    url { Faker::Internet.url }
    shortcode { SecureRandom.urlsafe_base64(4) }
  end
end
