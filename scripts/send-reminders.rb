# Small script for sending out email reminders to people who haven't checked
# in for a while
include Merb::MailerMixin

# Should this be something else?
SENDER = 'moneydown@toma.to'
DAYS   = 3

def main
  CurrentRound.instance.participants.each do |p|

    if p.last_weighin_delta > DAYS
      send_mail(ReminderMailer, :notify, {
        :from    => SENDER,
        :to      => p.user.email,
        :subject => "MoneyDown: Hey - you've not entered your weight in a while.."
      }, { :user => p.user })

      Merb.logger.info("Sent reminder email to: #{p.user.email}")
    end
  end
end

main
