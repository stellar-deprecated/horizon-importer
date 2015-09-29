class StellarCore::FeeMeta < StellarCore::Base
  self.table_name  = "txfeehistory"
  self.primary_key = "txid"


  def xdr
    self.txchanges
  end
end
