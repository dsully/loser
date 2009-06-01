class Summary < Application

  def index
    populate
  end

  def round
    if params["id"] and @round.id != params["id"]
      @round = Round.get(params["id"])
    end

    populate
  end

  def populate
    @round ||= CurrentRound.instance

    render :template => 'summary/index'
  end
end
