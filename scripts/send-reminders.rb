# Small script for sending out email reminders to people who haven't checked
# in for a while
include Merb::MailerMixin

# Should this be something else?
SENDER = 'moneydown@toma.to'
DAYS   = 3

def main
  CurrentRound.instance.users.each do |user|

    if user.last_weighin_delta > DAYS
      send_mail(ReminderMailer, :notify, {
        :from    => SENDER,
        :to      => user.email,
        :subject => "MoneyDown: Hey - you've not entered your weight in a while.."
      }, { :user => user })

    end
  end
end

main
