class User
  include DataMapper::Resource

  property :id,     Serial
  property :login,  String, :index => true
  property :name,   String

  property :email,  String, :index => true, :nullable => false, :unique => true, :format => :email_address, :messages => {
    :presence  => "We need your email address.",
    :is_unique => "We already have that email.",
    :format    => "Doesn't look like an email address to me ..."
  }

  validates_present :name
  validates_present :login

  property :admin,  Boolean, :default => false

  has n, :weighings, :order => [ :date ]
  has n, :rounds, :through => :weighings, :mutable => true

  # Method for Chart to treat participants and users the same.
  def user
    self
  end

  def start_weight
    @start_weight ||= weighings.first.weight
  end

  def <=>(o)
    self.name <=> o.name
  end

  def export
    exported = {}

    exported["user"] = {}
    exported["user"]["name"]  = self.name
    exported["user"]["login"] = self.login
    exported["user"]["email"] = self.email

    exported["rounds"] = {}

    self.rounds.each do |round|

      exported["rounds"][round.id] = {}
      exported["rounds"][round.id]["start"]  = round.start
      exported["rounds"][round.id]["weeks"]  = round.weeks
      exported["rounds"][round.id]["ante"]   = round.ante
      exported["rounds"][round.id]["target"] = round.target

      exported["rounds"][round.id]["weighings"] = {}

      round.weighings.each do |w|
        exported["rounds"][round.id]["weighings"][w.ymd] = w.weight
      end
    end

    exported
  end

end
