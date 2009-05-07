class Chart < Application

  def index
    @round = Round.get(2)
    @data  = []

    @round.users.each do |u|
      @data << {
        "label" => u.name,
        "data"  => u.weighings.collect do |w|
          # Javascript needs the timestamps in milliseconds.
          [ Time.parse(w.date.to_s).to_i * 1000, (w.weight - u.start_weight).round_at(2) ]
        end
      }
    end

    render
  end
end
