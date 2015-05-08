class History::Account < History::Base

  validates :id, uniqueness: true
  validates :address, uniqueness: true

end
