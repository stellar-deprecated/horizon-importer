class StellarCore::TrustLine < StellarCore::Base
  self.table_name   = :trustlines
  self.primary_keys = :accountid, :assettype, :issuer, :assetcode

  belongs_to :account, class_name: "StellarCore::Account", foreign_key: :accountid

  alias_attribute :asset_code, :assetcode
  alias_attribute :asset_type, :assettype


  def asset_type_s
    case asset_type
    when Stellar::AssetType.asset_type_credit_alphanum4
      "credit_alphanum4"
    when Stellar::AssetType.asset_type_credit_alphanum12
      "credit_alphanum12"
    else
      raise "Unknown asset type #{asset_type} on trustline"
    end
  end
end
