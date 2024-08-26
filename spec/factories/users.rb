# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'helloworld12' }
    name { Faker::Name.name }
  end
end
