class History::Transaction < History::Base
  # TODO: uncomment when low card system is fixed
  # has_low_card_table :status

  include Pageable

  self.primary_key = 'order'

  validates :order, presence: true

  before_validation :make_order


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
    order(:order) 
  }

  scope :before_token, ->(paging_token) {
    where('"order" < ?', paging_token)
  }

  scope :after_token, ->(paging_token) {
    where('"order" > ?', paging_token)
  }

  def to_param
    transaction_hash
  end

  def to_paging_token
    order.to_s
  end

  private
  def make_order
    return if self.ledger_sequence.blank?
    return if self.application_order.blank?

    self.order = TotalOrderId.make(ledger_sequence, application_order)
  end
end
