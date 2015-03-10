class Hayashi::TrustLine < Hayashi::Base
  self.table_name   = :trustlines
  self.primary_keys = :accountid, :issuer, :isocurrency
  
  belongs_to :account, class_name: "Hayashi::Account", foreign_key: :accountid

  alias_attribute :currency_code, :isocurrency
end
