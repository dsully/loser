class Summary < Application

  def index
    @user  = User.first(:login => 'sully')
    @round = CurrentRound.instance

    render
  end
end
