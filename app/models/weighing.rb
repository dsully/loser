class Weighing
  include DataMapper::Resource

  property :id,     Serial
  property :date,   Date,  :index  => true
  property :weight, Float, :nullable => true

  belongs_to :user
  belongs_to :round

  def ymd
    date.to_time.strftime("%Y-%m-%d")
  end
end
