class User
  include DataMapper::Resource

  property :id,     Serial
  property :login,  String, :index => true
  property :name,   String
  property :anted,  Boolean, :default => false

  has n, :weighings, :order => [ :date ]
  belongs_to :round

  MAX_OWED = 100
  MIN_OWED = 0

  # These are not query optimized at all.
  def datapoints
    weighings.compact.size
  end

  def start_weight
    weighings.first.weight
  end

  def current_weight
    weighings.last.weight
  end

  def net_loss
    (start_weight - current_weight).round_at(2)
  end

  def final_weight
    current_weight if round.days_remaining <= 0
  end

  def owed
    [MIN_OWED, [((round.target - net_loss) * round.ante), MAX_OWED].min].max.to_i
  end

  def payout
    if net_loss >= round.target
      ((round.total_prize_pool * net_loss) / round.sum_of_hit_target).to_i
    else
      0
    end
  end
end
