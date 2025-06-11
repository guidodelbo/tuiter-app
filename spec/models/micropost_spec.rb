# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Micropost do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.build(:micropost, user: user) }

  describe 'validations' do
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

    context 'when an image is attached' do
      let(:valid_image) { Rails.root.join('spec', 'fixtures', 'files', 'kitten.jpg') }
      let(:large_file) { StringIO.new('x' * 6.megabytes) }

      it 'accepts valid image formats and sizes', :aggregate_failures do
        %w[image/jpeg image/gif image/png].each do |content_type|
          micropost.image.attach(io: File.open(valid_image), filename: 'test.jpg', content_type: content_type)

          expect(micropost).to be_valid

          micropost.image.purge
        end
      end

      it 'rejects invalid formats', :aggregate_failures do
        micropost.image.attach(io: StringIO.new("fake pdf"), filename: 'test.pdf', content_type: 'application/pdf')

        expect(micropost).not_to be_valid
        expect(micropost.errors[:image]).to include('must be a valid image format')
      end

      it 'rejects files over 5MB', :aggregate_failures do
        micropost.image.attach(io: large_file, filename: 'large.jpg', content_type: 'image/jpeg')

        expect(micropost).not_to be_valid
        expect(micropost.errors[:image]).to include('should be less than 5MB')
      end
    end
  end

  describe 'order' do
    it 'is most recent first' do
      FactoryBot.create(:micropost, created_at: 1.day.ago)
      most_recent = FactoryBot.create(:micropost, created_at: Time.zone.now)

      expect(described_class.first).to eq(most_recent)
    end
  end
end
