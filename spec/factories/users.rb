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

  trait :admin do
    admin { true }
  end

  trait :pending_password_reset do
    after(:create) do |user|
      user.create_reset_digest
    end
  end

  trait :pending_activation do
    activated { false }
    activated_at { nil }
  end
end
