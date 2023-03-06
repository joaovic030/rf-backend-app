class NotificationMailer < ApplicationMailer
  default from: 'notifications-rf@gmail.com'
  # password: 123$%^As

  def send_notification
    @user = params[:user]
    @message_txt = params[:message]

    mail(to: @user.email, subject: "There is a new update about a player")
  end
end
