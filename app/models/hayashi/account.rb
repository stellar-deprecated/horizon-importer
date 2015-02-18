class Hayashi::Account < Hayashi::Base
  establish_connection :hayashi
  self.table_name  = "accounts"
  self.primary_key = "accountid"

end
