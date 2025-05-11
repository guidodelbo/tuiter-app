class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.email.from
  layout 'mailer'
end
