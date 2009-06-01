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

  validates_with_method :start, :valid_start_weight?

  # These are not query optimized at all.
  def datapoints
    weighings.compact.size
  end

  def start_weight
    start
  end

  def current_weight
    if @current.nil?
      if datapoints > 0
        @current = weighings.last.weight
      else
        @current = start_weight
      end
    end

    @current
  end

  def last_weighin_delta
    Date.today - weighings.last.date
  end

  def net_loss
    (start_weight - current_weight).round_at(2)
  end

  def owed
    max_owed = round.ante * round.target
    min_owed = 0

    [min_owed, [((round.target - net_loss) * round.ante), max_owed].min].max.to_i
  end

  def payout
    if net_loss >= round.target
      ((round.total_prize_pool * net_loss) / round.sum_of_hit_target).to_i
    else
      0
    end
  end

  def valid_start_weight?
    return [false, "I doubt you weigh 0lbs."] if @start <= 0
    return [false, "I doubt you weigh less than 100lbs."] if @start <= 100
    true
  end

  # DM can't handle sort on an association yet that doesn't have an actual column in the table.
  def <=>(o)
    self.user.name <=> o.user.name
  end
end
