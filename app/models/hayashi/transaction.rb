class Hayashi::Transaction < Hayashi::Base
  self.table_name  = "txhistory"
  self.primary_key = "txid"

  delegate :result, to: :result_pair

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

end
