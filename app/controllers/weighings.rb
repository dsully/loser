class Weighings < Application

  def index
    @dates = Hash.new

    @round.weighings.each do |w|
      (@dates[w.ymd] ||= {})[w.user.name] = w.weight
    end

    render
  end

  def update
    weighings = session.user.weighings

    params['weighings'].each_pair do |date, value|

      # Users can't currently delete entries by clearing out the value.
      # Not sure if this is an issue or not.
      next if value.empty?

      # Can't do this in validators because assigning w.weight = value causes an
      # implicit .to_f to be called, which will be turned into a 0.0 for most
      # cases (ie: alpha). We want to give the user a better error message.
      unless is_numeric?(value)
        return redirect "/weighings", :message => { :notice => "Invalid value: '#{value}'" }
      end

      w        = weighings.first(:date => date) || weighings.build(:date => date, :round => @round)
      w.weight = value

      unless w.save
        return redirect "/weighings", :message => { :notice => w.errors.values.join("\n") }
      end
    end

    redirect "/weighings"
  end
end
