class History::TransactionParticipant < History::Base

  belongs_to :history_transaction, {
    class_name: "History::Transaction", 
    foreign_key: :transaction_hash, 
    primary_key: :transaction_hash,
  }
end
