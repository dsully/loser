class CurrentRound
  include DataMapper::Resource

  property :round,  Integer, :key => true

  def self.instance
    Round.get(self.first.round)
  end
end
