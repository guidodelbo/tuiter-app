require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'God Zilla', email: 'me@godzilla.org', password: 'foobar', password_confirmation: 'foobar')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = ' '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = ' '
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.name = "#{'a' * 244}@example.com"
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org
                           user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email addresses should be saved as lowercase' do
    mixed_case_email = 'mIxeDCAse@EXaMpLe.coM'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'password should be present' do
    @user.password = @user.password_confirmation = ' ' * 10
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'associated microposts should be destroyed' do
    @user.save
    @user.microposts.create!(content: 'Lorem ipsum')

    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test 'should follow and unfollow a user' do
    michael = users(:michael)
    natalie = users(:natalie)

    assert_not michael.following?(natalie)
    michael.follow(natalie)
    assert michael.following?(natalie)
    assert natalie.followers.include?(michael)

    michael.unfollow(natalie)
    assert_not michael.following?(natalie)

    michael.follow(michael)
    assert_not michael.following?(michael)
  end

  test 'feed should have the right posts' do
    michael = users(:michael)
    clara = users(:clara)
    tom = users(:tom)

    assert_equal michael.feed.distinct, michael.feed

    # posts from followed user
    clara.microposts.each do |claras_posts|
      assert michael.feed.include?(claras_posts)
    end

    # self-posts for user with followers
    michael.microposts.each do |michael_posts|
      assert michael.feed.include?(michael_posts)
    end

    # self-posts for user with no followers
    # posts from unfollowed user
    tom.microposts.each do |toms_posts|
      assert tom.feed.include?(toms_posts)
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end
