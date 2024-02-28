require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:natalie)
  end

  test 'should get new' do
    get signup_path

    assert_response :success
    assert_select 'title', full_title('Sign up')
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)

    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: 'Robert', email: 'foo@bar.com' } }

    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should redirect edit when logged in as a wrong user' do
    log_in_as(@other_user)
    get edit_user_path(@user)

    assert flash.empty?
    assert_redirected_to root_path
  end

  test 'should redirect update when logged in as a wrong user' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: 'Rose', email: 'foo@bar.com' } }

    assert flash.empty?
    assert_redirected_to root_path
  end

  test 'should redirect index when not logged in' do
    get users_path

    assert_redirected_to login_path
  end

  test 'should not allow the admin property to be edited via the web' do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: { admin: true } }
    @other_user.reload
    assert_not @other_user.admin?
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end

    assert_redirected_to login_url
  end

  test 'should redirect destroy when logged in as a non-admin' do
    log_in_as(@other_user)

    assert_no_difference 'User.count' do
      delete user_path(@user)
    end

    assert_redirected_to root_url
  end
end
