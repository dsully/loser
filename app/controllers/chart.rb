class Chart < Application

  def index
    @round = CurrentRound.instance
    @data  = []

    @round.users.each do |u|
      records = u.weighings.collect do |w|
        # Javascript needs the timestamps in milliseconds.
        [ w.date.to_time.to_i * 1000, (w.weight - u.start_weight).round_at(2) ]
      end

      # Start out at 0.
      records.unshift [ (records.first.first - (1.day.to_i * 1000)), 0 ]

      @data << {
        "label" => u.name,
        "data"  => records
      }
    end

    render
  end
end
