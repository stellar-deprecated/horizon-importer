class Hayashi::LedgerHeader < Hayashi::Base
  self.table_name  = "ledgerheaders"
  self.primary_key = "ledgerhash"
  
end
