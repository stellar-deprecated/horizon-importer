class History::Operation < History::Base
  include Pageable

  # disable STI
  def self.inheritance_column ; nil ; end

  self.primary_key = "id"
  validates :id, presence: true, uniqueness: true

  before_validation :make_id

  scope :application_order, ->(){ order(:id) }
  scope :before_token,      ->(cursor) { where('id < ?', cursor) }
  scope :after_token,       ->(cursor) { where('id > ?', cursor) }

  def type_as_enum
    Stellar::OperationType.by_value[type]
  end

  def to_param
    id
  end

  def to_paging_token
    id.to_s
  end

  private
  def make_id
    return if self.transaction_id.blank?
    return if self.application_order.blank?

    ledger_sequence, tx_order, _ = TotalOrderId.parse(self.transaction_id)

    self.id = TotalOrderId.make(ledger_sequence, tx_order, application_order)
  end
end
