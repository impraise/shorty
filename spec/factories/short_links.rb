FactoryBot.define do
  factory :short_link do
    url { Faker::Internet.url }
    shortcode { (0...6).map { ALPHABET[rand(ALPHABET.length)] }.join }
  end
end
