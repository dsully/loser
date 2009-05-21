class Chart < Application

  def index
    @data = []

    @round.participants.each do |p|
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

    render
  end
end
