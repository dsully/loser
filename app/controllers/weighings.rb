class Weighings < Application

  def index
    @dates = Hash.new

    # XXX - should be able to be done via a join?
    @round.users.each do |u|
      u.weighings.each do |w|

        date = w.date.to_time.strftime("%Y-%m-%d")

        @dates[date] ||= Hash.new
        @dates[date][u.name] = w.weight
      end
    end

    render
  end

  def update
    params['weighings'].each_pair do |date, value|
      next if value.empty?

      unless is_numeric?(value)
        return redirect "/weighings", :message => { :notice => "Invalid value: \"#{value}\"" }
      end

      unless value.to_f.nonzero?
        return redirect "/weighings", :message => { :notice => "You can't weigh nothing!" }
      end

      unless is_valid_date?(date)
        return redirect "/weighings", :message => { :notice => "Invalid date: #{date}" }
      end
    end

    params['weighings'].each_pair do |date, value|

      # Users can't currently delete entries by clearing out the value. Not sure if
      # this is an issue or not.
      next if value.empty?

      if w = session.user.weighings(:date => date).first

        if w.weight != value.to_f
          w.weight = value.to_f
          w.save
        end

      else
        session.user.weighings.build(
          :date   => date,
          :weight => value,
          :round  => @round
        )
      end
    end

    session.user.save

    redirect "/weighings"
  end
end
