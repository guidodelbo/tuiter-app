require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'

    patch user_path(@user), params: { user: { name: '',
                                              email: 'notvalid@email',
                                              password: 'not',
                                              password_confirmation: 'valid' } }
    assert_template 'users/edit'
    assert_select 'div.alert', text: /the form contains 4 errors/i
  end

  test 'successful edit with friendly forwarding' do
    # fails because user is not logged in
    get edit_user_path(@user)
    assert_not_nil session[:forwarding_url]
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    assert_nil session[:forwarding_url]

    name = 'New Name'
    email = 'new@email.com'
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: '' } }

    assert_not flash.empty?
    assert_select 'div.alert', count: 0
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
