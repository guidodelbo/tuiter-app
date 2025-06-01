# frozen_string_literal: true

require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    log_in_as(@user)
    get root_path
  end

  test 'micropost interface' do
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: '' } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2'

    content = 'testing content'
    image = fixture_file_upload('kitten.jpg', 'image/jpeg')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, image: image } }
    end
    assert assigns(:micropost).image.attached?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    get user_path(users(:natalie))
    assert_select 'a', { text: 'delete', count: 0 }
  end

  test 'micropost sidebar count' do
    assert_match "#{@user.microposts.count} tuits", response.body

    other_user = users(:clara)
    log_in_as(other_user)
    get root_path
    assert_match '0 tuits', response.body
    other_user.microposts.create!(content: 'testing content')
    get root_path
    assert_match '1 tuit', response.body
  end

  test 'feed on Home page' do
    @user.feed.paginate(page: 1).each do |micropost|
      assert_match CGI.escapeHTML(micropost.content), response.body
    end
  end
end
