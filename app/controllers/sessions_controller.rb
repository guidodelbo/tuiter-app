class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        should_remember_user = params[:session][:remember_me] == '1'
        should_remember_user ? remember(user) : forget(user)
        log_in user
        redirect_to forwarding_url || user
      else
        message = 'Account not activated, check your email for the activation link'
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email or password'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
