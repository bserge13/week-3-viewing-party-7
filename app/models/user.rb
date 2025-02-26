class User <ApplicationRecord 
  validates_presence_of :email, :name, :password 
  validates_uniqueness_of :email
  validates_confirmation_of :password
  has_many :viewing_parties
  has_secure_password

  enum role: %w(default admin)
end 