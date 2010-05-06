class Summary < Application

  def index
    populate_summary
  end

  def round
    if params["id"] and @round.id != params["id"]
      @round = Round.get(params["id"])
    end

    populate_summary
  end

  def populate_summary
    @round ||= CurrentRound.instance

    render :template => 'summary/index'
  end
end
