class Participant
  include DataMapper::Resource

  property :id,     Serial

  # Starting weight for this around.
  property :start,  Float
  property :paid,   Boolean, :default => false

  property :user_id,  Integer, :index => true
  property :round_id, Integer, :index => true

  belongs_to :round
  belongs_to :user

  has n, :weighings, :order => [ :date ]

  MAX_OWED = 100
  MIN_OWED = 0

  # These are not query optimized at all.
  def datapoints
    weighings.compact.size
  end

  def start_weight
    start
  end

  def current_weight
    @current ||= weighings.last.weight
  end

  def last_weighin_delta
    Date.today - weighings.last.date
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

  # DM can't handle sort on an association yet that doesn't have an actual column in the table.
  def <=>(o)
    self.user.name <=> o.user.name
  end
end
