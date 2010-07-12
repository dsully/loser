class CurrentRound
  include DataMapper::Resource

  property :round,  Integer, :key => true

  validates_numericality_of :round

  def self.instance
    Round.get(self.first.round)
  end
end
