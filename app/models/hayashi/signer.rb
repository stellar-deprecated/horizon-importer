class Hayashi::Signer < Hayashi::Base
  establish_connection :hayashi
  self.table_name   = :signers
  self.primary_keys = :accountid, :publickey

  belongs_to :account, class_name: "Hayashi::Account", foreign_key: :accountid
end
