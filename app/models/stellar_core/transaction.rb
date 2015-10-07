class StellarCore::Transaction < StellarCore::Base
  self.table_name  = "txhistory"
  self.primary_key = "txid"

  belongs_to :ledger_header, {
    class_name: "StellarCore::LedgerHeader",
    foreign_key: :ledgerseq,
    primary_key: :ledgerseq,
  }
  
  has_one :fee_meta, {
    class_name: "StellarCore::FeeMeta",
    foreign_key: "txid",
    primary_key: "txid",
  }

  delegate :tx,          to: :envelope
  delegate :result,      to: :result_pair
  delegate :min_ledger,  to: :tx
  delegate :max_ledger,  to: :tx
  delegate :operations,  to: :tx

  def success?
    result.result.code == Stellar::TransactionResultCode.tx_success
  end

  def envelope
    raw_envelope = Stellar::Convert.from_base64(self.txbody)
    Stellar::TransactionEnvelope.from_xdr(raw_envelope)
  end
  memoize :envelope

  def result_pair
    raw_result = Stellar::Convert.from_base64(self.txresult)
    Stellar::TransactionResultPair.from_xdr(raw_result)
  end
  memoize :result_pair

  def meta
    raw_meta = Stellar::Convert.from_base64(self.txmeta)
    Stellar::TransactionMeta.from_xdr(raw_meta)
  end
  memoize :meta

  def submitting_account
    self.envelope.tx.source_account
  end
  alias source_account submitting_account

  def submitting_address
    Stellar::Convert.pk_to_address(submitting_account)
  end

  def submitting_sequence
    tx.seq_num
  end

  def fee_paid
    result.fee_charged
  end

  def result_code
    result.result.switch
  end

  def result_code_s
    result_code.name
  end

  def participants
    results = []
    all_changes = meta.operations!.flat_map(&:changes)
    all_changes.each do |change|
      data = case change.type
             when Stellar::LedgerEntryChangeType.ledger_entry_created
               change.created!.data
             when Stellar::LedgerEntryChangeType.ledger_entry_updated
               change.updated!.data
             when Stellar::LedgerEntryChangeType.ledger_entry_removed
               change.removed!
             else
               raise "Unknown ledger entry change type: #{change.type}"
             end


      next unless data.type == Stellar::LedgerEntryType.account

      results << data.account!.account_id
    end

    results.uniq
  end
  memoize :participants


  def participant_addresses
    participants.map{|a| Stellar::Convert.pk_to_address(a)}
  end
  memoize :participant_addresses

  def operations_of_type(type)
    operations.select{|op| op.body.type == type }
  end

  def operation_results
    # TransactionResult => TransactionResult::Result => Array<OperationResult>
    result.result.results!
  end

  def operation_count
    operations.length
  end

  memoize def operations_with_results
    operations.zip(operation_results)
  end

  def txresult_without_pair
    Stellar::Convert.to_base64 result.to_xdr
  end

  def signatures
    envelope.signatures.map{|s| Stellar::Convert.to_base64(s.signature)}
  end

  def memo_type
    type = envelope.tx.memo.type
    case type
    when Stellar::MemoType.memo_none ;    "none"
    when Stellar::MemoType.memo_text ;    "text"
    when Stellar::MemoType.memo_id ;      "id"
    when Stellar::MemoType.memo_hash ;    "hash"
    when Stellar::MemoType.memo_return ;  "return"
    else
      raise "Unknown memo type: #{type}"
    end
  end

  def memo
    case memo_type
    when "none" ;    nil
    when "text" ;    envelope.tx.memo.text!
    when "id" ;      envelope.tx.memo.id!.to_s
    when "hash" ;    Stellar::Convert.to_base64(envelope.tx.memo.hash!)
    when "return" ;  Stellar::Convert.to_base64(envelope.tx.memo.ret_hash!)
    else
      raise "Unknown memo type: #{type}"
    end
  end

  def time_bounds
    tb = envelope.tx.time_bounds
    return nil if tb.blank?

    tb.min_time..tb.max_time
  end

end
