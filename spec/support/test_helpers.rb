# frozen_string_literal: true

module RequestSpecsHelpers
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: {
      session: {
        email: user.email,
        password: password,
        remember_me: remember_me
      }
    }
  end

  def is_logged_in?(user)
    session[:user_id] == user.id
  end
end

module SystemSpecsHelpers
  def log_in_as(user, password: 'password')
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_button 'Log in'
  end
end

RSpec.configure do |config|
  config.include RequestSpecsHelpers, type: :request
  config.include SystemSpecsHelpers, type: :system
end
