# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Micropost do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.build(:micropost, user: user) }

  it 'is valid with valid attributes' do
    expect(micropost).to be_valid
  end

  it 'is not valid without a user_id', :aggregate_failures do
    micropost.user = nil
    expect(micropost).not_to be_valid
    expect(micropost.errors.full_messages).to include('User must exist')
  end

  it 'is not valid without content', :aggregate_failures do
    micropost.content = '      '
    expect(micropost).not_to be_valid
    expect(micropost.errors.full_messages).to include('Content can\'t be blank')
  end

  it 'is not valid with content longer than 140 characters', :aggregate_failures do
    micropost.content = 'a' * 141
    expect(micropost).not_to be_valid
    expect(micropost.errors.full_messages).to include('Content is too long (maximum is 140 characters)')
  end

  describe 'order' do
    it 'is most recent first' do
      FactoryBot.create(:micropost, created_at: 1.day.ago)
      most_recent = FactoryBot.create(:micropost, created_at: Time.zone.now)

      expect(described_class.first).to eq(most_recent)
    end
  end
end
