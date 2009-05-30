class Summary < Application

  def index
    render
  end

  def round
    if params["id"] and @round.id != params["id"]
      @round = Round.get(params["id"])
    end

    @round ||= CurrentRound.instance

    render :template => 'summary/index'
  end
end
