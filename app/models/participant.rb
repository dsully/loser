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
      @current = (datapoints > 0) ? weighings.last.weight : start_weight
    end

    @current
  end

  def last_weighin_delta
    Date.today - weighings.last.date
  end

  def net_loss
    (start_weight - current_weight).round_at(2)
  end

  # Per the mail list - the average of the lowest 3 weights of the last week.
  def final_weight
    if round.days_remaining <= 0
      last_week = (round.start + round.days) - 7
      weights   = weighings.all(:date.gte => last_week).collect { |w| w.weight }.sort

      if weights.size >= 3
        (weights[0..2].sum / 3.0).round_at(1)
      else
        weighings.last.weight
      end
    else
      "-"
    end
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
