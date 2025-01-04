class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user

    mail(
      subject: 'Tuiter account activation',
      to: user.email,
      track_opens: 'true'
    )
  end

  def password_reset(user)
    @user = user

    mail(
      subject: 'Tuiter password reset',
      to: user.email,
      track_opens: 'true'
    )
  end
end
