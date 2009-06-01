class Round
  include DataMapper::Resource

  property :id,     Serial
  property :weeks,  Integer
  property :start,  Date

  property :ante,   Integer

  # Total pounds to lose for this round.
  property :target, Integer

  validates_present :start
  validates_is_number :weeks
  validates_is_number :ante
  validates_is_number :target

  has n, :weighings, :order => [ :date ]
  has n, :participants

  def total_prize_pool
    participants.collect { |p| p.owed }.sum + (participants.size * ante)
  end

  def total_lost
    participants.collect { |p| p.net_loss }.sum
  end

  def sum_of_hit_target
    participants.select { |p| p.net_loss >= target }.collect { |p| p.net_loss }.sum
  end

  def mollies
    (total_lost.to_f / 106.0).round_at(2)
  end

  def days
    weeks * 7
  end

  def finished?
    Date.today > (start + days - 1)
  end

  def days_complete
    finished? ? days : (Date.today - start).to_i
  end

  def days_remaining
    days - days_complete
  end

  def days_complete_percent
    ((days_complete.to_f / days.to_f) * 100).round
  end

  def days_remaining_percent
    100 - days_complete_percent
  end
end
