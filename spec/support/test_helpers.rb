# frozen_string_literal: true

module TestHelpers
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: {
      session: {
        email: user.email,
        password: password,
        remember_me: remember_me
      }
    }
  end

  # def log_in_as(user)
  #   session[:user_id] = user.id
  # end

  def is_logged_in?(user)
    session[:user_id] == user.id
  end
end

RSpec.configure do |config|
  config.include TestHelpers
end
