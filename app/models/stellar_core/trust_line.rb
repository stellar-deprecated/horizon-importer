class StellarCore::TrustLine < StellarCore::Base
  self.table_name   = :trustlines
  self.primary_keys = :accountid, :issuer, :isocurrency
  
  belongs_to :account, class_name: "StellarCore::Account", foreign_key: :accountid

  alias_attribute :currency_code, :isocurrency
end
