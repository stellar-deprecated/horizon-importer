class TransactionSubmission
  extend Memoist
  include Instrumentation
  
  RESULTS = [

    # the transaction was suffiently malformed that we could not interpet it
    :malformed,

    # the hash for this transaction hash is either in the history database
    # or is in the stellar core database
    :already_finished,

    # the transaction was submitted and received by stellar core
    :received,

    # the submission to stellar core failed, and was not recieved by the network
    :failed,

    # we could not connect to stellar core and submit the transaction
    :connection_failed
  ]

  instrument :process

  attr_reader :tx_envelope

  # 
  # Create a new submission from a provided xdr-serialized, hex-encoded 
  # transaction envelope.
  # 
  # @param tx_envelope [String] the transaction envelope
  # 
  def initialize(tx_envelope)
    @tx_envelope = tx_envelope
  end

  # 
  # Process this submission:
  # 
  # - pre-validate it
  # - submit it to stellar core if needed
  # - interpret the submission to stellar-core to populate the "submission result"
  # 
  def process

    if malformed?
      @result = :malformed
      return
    end

    if finished?
      @result = :already_finished
      return
    end
    
    @submission_response = $stellard.get("tx", blob: tx_envelope)

    if received?
      @result = :received
    else
      @result = :failed
    end
  rescue Faraday::ConnectionFailed
    @result = :connection_failed
  end

  # 
  # Represents the result of this submission, and not necessarily that of the
  # transaction that this submission contains.  See `TransactionSubmission::RESULTS` 
  # for a list of valid results along with explanations for each scenario.
  # 
  # @return [Symbol] the result of this submission
  def result
    @result
  end

  def received?
    return false if @submission_response.blank?

    @submission_response.body["wasReceived"]
  end

  def malformed?
    parsed_envelope.nil?
  end

  def finished?
    return false if @skip_finished_check
    
    history_transaction.present? || core_transaction.present?
  end

  def skip_finished_check!
    @skip_finished_check = true
  end

  def parsed_envelope
    raw = Convert.from_hex(tx_envelope)
    Stellar::TransactionEnvelope.from_xdr(raw)
  rescue EOFError
    nil
  end
  memoize :parsed_envelope

  def core_transaction
    Hayashi::Transaction.where(txid: transaction_hash).first
  end
  memoize :core_transaction

  def history_transaction
    History::Transaction.where(transaction_hash: transaction_hash).first
  end
  memoize :history_transaction

  def transaction_hash
    Convert.to_hex(parsed_envelope.tx.hash)
  end

  def submission_result
    return nil if @submission_response.blank?

    @submission_response.body["result"]
  end


end