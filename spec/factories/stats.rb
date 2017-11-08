FactoryBot.define do
  factory :stat do
    short_link_id 1
    redirect_count { Faker::Number.number(2).to_i }
  end
end
