class History::Transaction < History::Base
  # TODO: uncomment when low card system is fixed
  # has_low_card_table :status

  include Pageable


  validates :id, presence: true, uniqueness: true

  before_validation :make_id


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
    order(:id) 
  }

  scope :before_token, ->(paging_token) {
    where('id < ?', paging_token)
  }

  scope :after_token, ->(paging_token) {
    where('id > ?', paging_token)
  }

  def to_param
    transaction_hash
  end

  def to_paging_token
    id.to_s
  end

  private
  def make_id
    return if self.ledger_sequence.blank?
    return if self.application_order.blank?

    self.id = TotalOrderId.make(ledger_sequence, application_order)
  end
end
