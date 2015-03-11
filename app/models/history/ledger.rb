class History::Ledger < History::Base

  validates :sequence, {
    presence: true, 
    numericality: {greater_than_or_equal_to: 1}, 
    uniqueness: true,
  }

  validates :ledger_hash, {
    presence: true, 
    uniqueness: true,
    length: { is: 64 },
    hex: true,
  }

  validates :previous_ledger_hash, {
    uniqueness: true,
    length: { is: 64 },
    hex: true,
    allow_nil: true,
  }

  validates :closed_at, presence: true

  validates :transaction_count, {
    presence: true, 
    numericality: {greater_than_or_equal_to: 0}, 
  }

  validates :operation_count, {
    presence: true, 
    numericality: {greater_than_or_equal_to: 0}, 
  }


end
