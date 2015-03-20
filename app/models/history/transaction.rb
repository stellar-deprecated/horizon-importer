class History::Transaction < History::Base
  # TODO: uncomment when low card system is fixed
  # has_low_card_table :status

  include Pageable

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

  BEFORE_SQL_FRAGMENT = <<-EOS
    ledger_sequence < :ledger_sequence
    OR (
          ledger_sequence = :ledger_sequence 
      AND application_order < :application_order
    )
  EOS

  scope :before_token, ->(paging_token) {
    ledger_sequence, application_order = *parse_paging_token(paging_token)

    where(BEFORE_SQL_FRAGMENT, {
      ledger_sequence:ledger_sequence,
      application_order:application_order
    })
  }

  AFTER_SQL_FRAGMENT = <<-EOS
    ledger_sequence > :ledger_sequence
    OR (
          ledger_sequence = :ledger_sequence 
      AND application_order > :application_order
    )
  EOS

  scope :after_token, ->(paging_token) {
    ledger_sequence, application_order = *parse_paging_token(paging_token)

    where(AFTER_SQL_FRAGMENT, {
      ledger_sequence:ledger_sequence,
      application_order:application_order
    })
  }

  def to_param
    transaction_hash
  end

  def to_paging_token
    Convert.to_hex("#{ledger_sequence}:#{application_order}")
  end

  def self.parse_paging_token(paging_token)
    decoded = Convert.from_hex(paging_token)
    decoded.split(":", 2)
  end

end
