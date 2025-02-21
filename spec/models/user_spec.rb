# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:user) { FactoryBot.build(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user.name = ' '
      expect(user).not_to be_valid
    end

    it 'is not valid with a name longer than 50 characters' do
      user.name = 'a' * 51
      expect(user).not_to be_valid
    end

    it 'is not valid without an email' do
      user.email = ' '
      expect(user).not_to be_valid
    end

    it 'is not valid with an email longer than 255 characters' do
      user.email = "#{'a' * 244}@example.com"
      expect(user).not_to be_valid
    end

    it 'accepts valid email addresses' do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]

      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid, "#{valid_address.inspect} should be valid"
      end
    end

    it 'rejects invalid email addresses' do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com
                             foo@bar..com]

      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).not_to be_valid, "#{invalid_address.inspect} should be invalid"
      end
    end

    it 'is not valid with a duplicate email' do
      duplicate_user = user.dup
      user.save
      expect(duplicate_user).not_to be_valid
    end

    it 'saves email as lower-case' do
      mixed_case_email = 'Foo@ExAMPle.CoM'
      user.email = mixed_case_email
      user.save
      expect(user.reload.email).to eq(mixed_case_email.downcase)
    end

    it 'is not valid with a blank password' do
      user.password = user.password_confirmation = ' ' * 6
      expect(user).not_to be_valid
    end

    it 'is not valid with a password less than 6 characters' do
      user.password = user.password_confirmation = 'a' * 5
      expect(user).not_to be_valid
    end
  end

  describe 'authenticated?' do
    it 'returns false for a user with nil digest' do
      expect(user.authenticated?(:remember, '')).to be false
    end
  end

  describe 'associated microposts' do
    it 'destroys associated microposts' do
      user.save
      user.microposts.create!(content: 'Lorem ipsum')

      expect { user.destroy }.to change(Micropost, :count).by(-1)
    end
  end

  describe 'following and unfollowing a user' do
    let(:other_user) { FactoryBot.create(:user) }

    before do
      user.save
    end

    it 'follows a user' do
      expect(user.following?(other_user)).to be false

      user.follow(other_user)
      expect(user.following?(other_user)).to be true
      expect(other_user.followers.include?(user)).to be true
    end

    it 'unfollows a user' do
      user.follow(other_user)
      expect(user.following?(other_user)).to be true

      user.unfollow(other_user)
      expect(user.following?(other_user)).to be false
      expect(other_user.followers.include?(user)).to be false
    end
  end

  describe 'feed' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let(:third_user) { FactoryBot.create(:user) }

    before do
      user.microposts << FactoryBot.create_list(:micropost, 3, user: user)
      other_user.microposts << FactoryBot.create_list(:micropost, 3, user: other_user)
      third_user.microposts << FactoryBot.create_list(:micropost, 3, user: third_user)

      user.follow(other_user)
      user.follow(third_user)
      other_user.follow(user)
      third_user.follow(other_user)
    end

    it 'has the right posts' do
      other_user.microposts.each do |micropost|
        expect(user.feed.include?(micropost)).to be true
        expect(third_user.feed.include?(micropost)).to be true
      end

      user.microposts.each do |micropost|
        expect(other_user.feed.include?(micropost)).to be true
      end

      third_user.microposts.each do |micropost|
        expect(user.feed.include?(micropost)).to be true
      end
    end
  end
end
