require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: '' } }

    assert_template 'sessions/new'
    assert_not flash.empty?

    get root_path
    # we want flash message to show up only once
    assert flash.empty?
  end

  test 'login with valid email but invalid password' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email, password: 'invalid' } }

    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?

    get root_path
    assert flash.empty?
  end

  test 'login with valid information and then logout' do
    get login_path
    post login_path, params: { session: { email: @user.email, password: 'password' } }

    assert is_logged_in?
    assert_redirected_to @user

    follow_redirect!

    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)

    delete logout_path

    assert_not is_logged_in?
    assert_redirected_to root_url

    # Simulate a user clicking logout in a second window.
    delete logout_path

    follow_redirect!

    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end

  test 'login with remembering' do
    log_in_as(@user, remember_me: '1')

    remember_token = cookies[:remember_token]
    user = User.find_by(email: @user.email)

    assert user.authenticated?(:remember, remember_token)
  end

  test 'login without remembering' do
    # log in with remembering to set the cookie
    log_in_as(@user, remember_me: '1')
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end
end
