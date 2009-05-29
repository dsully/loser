class CurrentRound
  include DataMapper::Resource

  property :round,  Integer, :key => true

  validates_is_number :round

  def self.instance
    Round.get(self.first.round)
  end
end
