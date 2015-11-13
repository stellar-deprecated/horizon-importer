class StellarCore::FeeMeta < StellarCore::Base
  self.table_name  = "txfeehistory"
  self.primary_key = "txid"


  def xdr
    self.txchanges
  end

  def changes
    Stellar::LedgerEntryChanges.from_xdr(xdr, 'base64')
  end

end
