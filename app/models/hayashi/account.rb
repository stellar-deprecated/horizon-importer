class Hayashi::Account < Hayashi::Base
  establish_connection :hayashi
  self.table_name  = "accounts"
  self.primary_key = "accountid"

  has_many :signers, class_name: "Hayashi::Signer", foreign_key: [:accountid]
end
