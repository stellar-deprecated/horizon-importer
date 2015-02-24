class Hayashi::Transaction < Hayashi::Base
  self.table_name  = "txhistory"
  self.primary_key = "txid"
end
