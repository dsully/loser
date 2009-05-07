class Summary < Application

  def index
    @user  = User.first(:login => 'sully')
    @round = Round.get(2)

    render
  end
end
