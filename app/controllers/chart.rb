class Chart < Application

  # Show the graph for all participants of the current round
  def index
    generate(@round.participants)
    render
  end

  # Show the graph for a single participant (of a round)
  def participant
    participant = Participant.get(params["id"])

    if participant.user == session.user
      generate(Array(participant))
      render :template => 'chart/index'
    else
      redirect "/chart"
    end
  end

  # Show the graph for a single user, across multiple rounds.
  # TODO: Not yet working - need to collapse the lines.
  def user
    if params["id"] == session.user.id
      generate(Array(Participant.all(:user_id => params["id"])))
      render :template => 'chart/index'
    else
      redirect "/chart"
    end
  end

  # Show the graph for all participants of a round.
  def round
    generate(Round.get(params["id"]).participants)
    render :template => 'chart/index'
  end

  def generate(participants)
    @data = []

    participants.sort.each do |p|
      records = p.weighings.collect do |w|
        # Javascript needs the timestamps in milliseconds.
        [ w.date.to_time.to_i * 1000, (w.weight - p.start_weight).round_at(2) ]
      end

      # Start out at 0.
      records.unshift [ (records.first.first - (1.day.to_i * 1000)), 0 ]

      @data << {
        "label" => p.user.name,
        "data"  => records
      }
    end
  end
end
