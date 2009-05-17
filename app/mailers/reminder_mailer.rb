class ReminderMailer < Merb::MailController

  # http://wiki.merbivore.com/howto/mailers
  def notify
    @user = params[:user]
    render_mail
  end

end
