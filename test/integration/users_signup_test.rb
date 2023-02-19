require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup submission' do
    get signup_path

    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '', email: 'user@invalid', password: 'foo',
                                        password_confirmation: 'bar' } }
    end

    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
    assert_select 'div.field_with_errors'
  end

  test 'valid signup submission' do
    get signup_path

    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Test Name', email: 'test@testmail.com',
                                 password: 'foobar', password_confirmation: 'foobar' } }
    end

    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert_select 'div.alert-success'
    assert is_logged_in?
  end
end