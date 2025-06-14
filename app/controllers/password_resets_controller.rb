# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email with password reset instructions was sent'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email address was not found'
      render 'new'
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update(user_params)
      # wipe user remember_digest to expire a potential hijacked session
      @user.forget
      reset_session
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = 'Password has been reset'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

      flash[:danger] = 'Wrong password reset link'
      redirect_to root_url
    end

    def check_expiration
      return unless @user.password_reset_expired?

      flash[:danger] = 'Password reset has expired'
      redirect_to new_password_reset_url
    end
end
