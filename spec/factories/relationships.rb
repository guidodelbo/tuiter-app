# frozen_string_literal: true

FactoryBot.define do
  factory :relationship do
    follower factory: :user
    followed factory: :user
  end
end
