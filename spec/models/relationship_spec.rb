# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship do
  let(:follower) { FactoryBot.create(:user) }
  let(:followed) { FactoryBot.create(:user) }
  let(:relationship) { described_class.new(follower_id: follower.id, followed_id: followed.id) }

  it 'is valid with valid attributes' do
    expect(relationship).to be_valid
  end

  it 'requires a follower_id' do
    relationship.follower_id = nil
    expect(relationship).not_to be_valid
  end

  it 'requires a followed_id' do
    relationship.followed_id = nil
    expect(relationship).not_to be_valid
  end
end
