# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password' }
    password_confirmation { 'password' }
    password_digest { User.digest('password') }
    activated { true }
    activated_at { Time.zone.now }
  end
end
