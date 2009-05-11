class Round
  include DataMapper::Resource

  property :id,     Serial
  property :weeks,  Integer
  property :start,  Date

  property :ante,   Integer

  # Total pounds to lose for this round.
  property :target, Integer

  has n, :users, :order => [ :name ]
  has n, :weighings, :order => [ :date ]

  def total_prize_pool
    users.collect { |u| u.owed }.sum + (users.size * ante)
  end

  def total_lost
    users.collect { |u| u.net_loss }.sum
  end

  def sum_of_hit_target
    users.select { |u| u.net_loss >= target }.collect { |u| u.net_loss }.sum
  end

  def mollies
    (total_lost.to_f / 106.0).round_at(2)
  end

  def days
    weeks * 7
  end

  def days_complete
    ((Time.now - start.to_time) / 1.day.to_i).round
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
