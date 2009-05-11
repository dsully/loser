class Application < Merb::Controller

  # All controllers get authentication by default.
  before :ensure_authenticated
  before :load_current_round

  def load_current_round
    if session and session.user and not @round
      @round = CurrentRound.instance
    end
  end
end
