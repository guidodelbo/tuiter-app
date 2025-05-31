# frozen_string_literal: true

FactoryBot.define do
  factory :micropost do
    content { Faker::Quote.famous_last_words }
    created_at { Faker::Time.between(from: 1.year.ago, to: Time.current) }
    user
  end
end
