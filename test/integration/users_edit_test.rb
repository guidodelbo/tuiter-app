require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'unsuccessful edit' do
    get edit_user_path(@user)
    assert_template 'users/edit'

    patch user_path(@user), params: { user: { name: '',
                                              email: 'notvalid@email',
                                              password: 'not',
                                              password_confirmation: 'valid' } }
    assert_template 'users/edit'
    assert_select 'div.alert', text: /the form contains 4 errors/i
  end

  test 'successful edit' do
    get edit_user_path(@user)
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
