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
end
