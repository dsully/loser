class Weighing
  include DataMapper::Resource
  include Merb::GlobalHelpers

  property :id,     Serial
  property :date,   Date,  :index  => true
  property :weight, Float, :nullable => true

  belongs_to :user
  belongs_to :round

  validates_with_method :date,   :method => :validate_date
  validates_with_method :weight, :method => :validate_weight

  def ymd
    date.to_time.strftime("%Y-%m-%d")
  end

  protected

  def validate_weight
    return [ false, "You can't weigh nothing!'" ] unless self.weight.to_f.nonzero?
    return true
  end

  def validate_date
    return [ false, "Invalid date: #{date}" ] unless is_valid_date? self.date
    return true
  end
end
