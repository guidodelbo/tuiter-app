class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user

    mail(
      subject: 'Tuiter account activation',
      to: user.email,
      from: ENV['EMAIL_FROM'],
      track_opens: 'true',
      message_stream: 'outbound'
    )
  end

  def password_reset
    @greeting = 'Hi'

    mail to: 'to@example.org'
  end
end
