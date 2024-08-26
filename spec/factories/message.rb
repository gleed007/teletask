FactoryBot.define do
  factory :message do
    association :user
    body { Faker::Lorem.sentence }
    status { 'pending' }
    external_id { Faker::Alphanumeric.alphanumeric(number: 10) }
  end
end
