class Summary < Application

  def index
    @user  = session.user
    @round = CurrentRound.instance

    render
  end
end
