# Mailer for Application
class Notifier < ApplicationMailer
  default from: 'lakewoodranchtsa@mctherealm.net'

  def verify_email(user)
    @user = user
    mail to: user.email, subject: 'Lakewood Ranch TSA Email Verification'
  end
end
