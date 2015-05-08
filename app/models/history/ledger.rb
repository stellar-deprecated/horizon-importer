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

  validates :id, presence: true, uniqueness: true

  before_validation :make_id

  # 
  # Validates that the previous hash `previous_hash` for a ledger to be imported
  # at sequence number `sequence` is allowed.
  # 
  # This method contributes to ensure that no forks occur within the history system.  
  # Any attempt to import a ledger that does not follow a previously seen ledger
  # will raise `History::BrokenHistoryChainError`
  # 
  # @param previous_hash [String] The hash 
  # @param sequence [type] the sequence number to validate for 
  # 
  # @raises History::BrokenHistoryChainError
  # 
  def self.validate_previous_ledger_hash!(previous_hash, sequence)
    expected_sequence = sequence - 1
    ledger = where(sequence:expected_sequence).first

    if ledger.blank?
      raise History::BrokenHistoryChainError, "Ledger #{expected_sequence} not found"
    end

    if ledger.ledger_hash != previous_hash
      raise History::BrokenHistoryChainError, 
        "Ledger #{expected_sequence} is not expected hash: #{previous_hash}\n" +
        "it actually is: #{ledger.ledger_hash}"
    end
  end

  def self.last_imported_ledger
    order(:sequence).last
  end

  private
  def make_id
    return if self.sequence.blank?
    self.id = TotalOrderId.make(self.sequence)
  end

end
