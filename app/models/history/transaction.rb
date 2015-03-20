class History::Transaction < History::Base
  # TODO: uncomment when low card system is fixed
  # has_low_card_table :status

  has_many :participants, {
    class_name: "History::TransactionParticipant", 
    foreign_key: :transaction_hash, 
    primary_key: :transaction_hash, 
  }

  scope :application_order, ->(){ order("ledger_sequence ASC, application_order ASC") }

  def to_param
    transaction_hash
  end

end
