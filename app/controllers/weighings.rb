class Weighings < Application

  def index
    populate_weighings
  end

  # If a specific round was specified.
  def round
    if params["id"] and @round.id != params["id"]
      @round = Round.get(params["id"])
    end

    populate_weighings
  end

  # Called by both index & round above.
  def populate_weighings
    @round ||= CurrentRound.instance
    @dates   = Hash.new

    @round.weighings.each do |w|
      (@dates[w.ymd] ||= {})[w.participant.id] = w.weight
    end

    render :template => 'weighings/index'
  end

  def update
    participant = Participant.first(:user_id => session.user.id, :round_id => @round.id)

    # XXXX - Need to have JS to only send the values that have actually changed.
    params['weighings'].each_pair do |date, value|

      # Users can't currently delete entries by clearing out the value.
      # Not sure if this is an issue or not.
      next if value.blank?

      # Can't do this in validators because assigning w.weight = value causes an
      # implicit .to_f to be called, which will be turned into a 0.0 for most
      # cases (ie: alpha). We want to give the user a better error message.
      unless is_numeric?(value)
        return redirect "/weighings", :message => { :notice => "Invalid value: '#{value}'" }
      end

      w        = participant.weighings.first(:date => date) ||
                 participant.weighings.build(:date => date, :round => @round, :user => session.user)
      w.weight = value

      unless w.save
        return redirect "/weighings", :message => { :notice => w.errors.values.join("\n") }
      end
    end

    redirect "/weighings"
  end
end
