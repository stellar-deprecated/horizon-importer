class Hayashi::Transaction < Hayashi::Base
  self.table_name  = "txhistory"
  self.primary_key = "txid"

  belongs_to :ledger_header, {
    class_name: "Hayashi::LedgerHeader", 
    foreign_key: :ledgerseq, 
    primary_key: :ledgerseq,
  }

  delegate :tx,          to: :envelope
  delegate :result,      to: :result_pair
  delegate :max_fee,     to: :tx
  delegate :min_ledger,  to: :tx
  delegate :max_ledger,  to: :tx
  delegate :operations,  to: :tx

  def envelope
    raw_envelope = Convert.from_base64(self.txbody)
    Stellar::TransactionEnvelope.from_xdr(raw_envelope)
  end
  memoize :envelope

  def result_pair
    raw_result = Convert.from_base64(self.txresult)
    Stellar::TransactionResultPair.from_xdr(raw_result)
  end
  memoize :result_pair

  def meta
    raw_meta = Convert.from_base64(self.txmeta)
    raw_meta = raw_meta[4..-1]# strip off rfc5531 record marking TODO: remove when txmeta is a bare xdr object
    Stellar::TransactionMeta.from_xdr(raw_meta)
  end
  memoize :meta

  def submitting_account
    self.envelope.tx.account
  end

  def submitting_address
    Convert.base58.check_encode(:account_id, submitting_account)
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

end
