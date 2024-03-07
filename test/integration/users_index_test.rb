require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:michael)
    @non_admin_user = users(:natalie)
  end

  test 'index as admin includes pagination and delete links' do
    log_in_as(@admin_user)
    first_page_of_users = User.paginate(page: 1)
    # make one user in the first page not activated
    first_page_of_users.first.toggle!(:activated)
    get users_path

    assert_template 'users/index'
    assert_select 'div.pagination', count: 2

    assigns(:users).each do |user|
      assert user.activated?
      assert_select 'a[href=?]', user_path(user), text: user.name
      assert_select 'a[href=?]', user_path(user), text: 'delete' unless user == @admin_user
    end

    assert_difference 'User.count', -1 do
      delete user_path(@non_admin_user)
    end
  end

  test 'index as non-admin' do
    log_in_as(@non_admin_user)
    get users_path

    assert_select 'a', text: 'delete', count: 0
  end
end
