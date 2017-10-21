# frozen_string_literal: true

FactoryBot.define do
  factory :short_url do
    url { Faker::Internet.url }
    short_code { SecureRandom.hex(3) }
    start_date { DateTime.now }
  end

  factory :encoded_short_url, parent: :short_url do
    short_code { Base64.urlsafe_encode64(SecureRandom.hex(3)) }
  end
end
