class History::Account < History::Base
  self.primary_key = "id"
  validates :id, uniqueness: true
  validates :address, uniqueness: true
end
