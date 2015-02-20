class PendingTransaction < ActiveRecord::Base
  include AASM
  include Instrumentation

  instrument :perform_submit

  has_one :sending_account, class_name: "Hayashi::Account", foreign_key: :sending_address

  before_validation :populate_from_xdr
  validates :state,             presence: true
  validates :sending_address,   presence: true
  validates :sending_sequence,  presence: true, numericality: true
  validates :tx_envelope,       presence: true
  validates :tx_hash,           presence: true
  validates_with TransactionPlausibilityValidator, :if => :validate_plausibility

  enum state: { 
    pending:   0, 
    submitted: 1,
    confirmed: 2,
    dead:      3,
    errored:   4,
  }


  aasm :column => :state do
    # upon initial submission to the api server, a PendingTransaction is `:pending`
    state :pending, :initial => true

    # after submission to a stellard node, a pending tx is `:submitted` meaning we
    # will revisit your state at each ledger close
    state :submitted, :before_enter => :perform_submit

    # after we see a transaction in a validated ledger, it transitions to `:confirmed`
    # and we can the safely report to requesters that the transaction was successfully
    # submitted
    state :confirmed

    # a transaction transitions to dead when we _know_ that is can never succeed. this
    # will happen, for example, when the max_ledger has elapsed and the transaction hasn't
    # been successfully included in a ledger, or if the tx itself is malformed
    state :dead

    # A transaction transitions to errored when the most recent submission was
    # met with an error response from the hayashi core.  Note: this is not `dead`,
    # an error transaction will be retried in the future.
    # 
    state :errored

    # This submit event will 
    event :submit do
      transitions to: :submitted, from: [:errored, :pending]
    end
  end

  attr_accessor :validate_plausibility

  # 
  # Deserializes tx_envelope and populates the various model fields
  # from the data contained within.
  # 
  def populate_from_xdr
    return if tx_envelope.blank?
    self.sending_address     = Convert.base58.check_encode(:account_id, parsed_envelope.tx.account)
    self.sending_sequence    = parsed_envelope.tx.seq_num
    self.max_ledger_sequence = parsed_envelope.tx.max_ledger
    self.min_ledger_sequence = parsed_envelope.tx.min_ledger
    self.tx_hash             = Convert.to_hex(parsed_envelope.tx.hash)
  end

  def parsed_envelope
    return @parsed_envelope if defined? @parsed_envelope
    raw = [tx_envelope].pack("H*")

    @parsed_envelope = Stellar::TransactionEnvelope.from_xdr(raw)
  end

  private

  # 
  # Performs an actual submission of this pending transaction to the core
  # server
  # 
  def perform_submit
    $stellard.get("tx", blob: tx_envelope)
  end

end
