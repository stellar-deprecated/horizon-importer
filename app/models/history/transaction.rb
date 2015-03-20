class History::Transaction < History::Base
  # TODO: uncomment when low card system is fixed
  # has_low_card_table :status

  has_many :participants, {
    class_name: "History::TransactionParticipant", 
    foreign_key: :transaction_hash, 
    primary_key: :transaction_hash, 
  }

  scope :for_account, ->(account_id) {
    joins(:participants).
    where(history_transaction_participants: {account: account_id})
  }

  scope :application_order, ->(){ 
    order("ledger_sequence ASC, application_order ASC") 
  }

  def to_param
    transaction_hash
  end

end
