class ReminderMailer < Merb::MailController

  # http://wiki.merbivore.com/howto/mailers
  def notify
    @p = params[:participant]
    render_mail
  end

end
