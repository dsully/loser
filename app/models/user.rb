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

  has n, :weighings, :order => [ :date ]
  has n, :rounds, :through => :weighings, :mutable => true
end
