class StellarCore::Account < StellarCore::Base
  self.table_name  = "accounts"
  self.primary_key = "accountid"

  has_many :signers,     class_name: "StellarCore::Signer",    foreign_key: [:accountid]
  has_many :trust_lines, class_name: "StellarCore::TrustLine", foreign_key: [:accountid]

  alias_attribute :sequence, :seqnum
  alias_attribute :address,  :accountid

  def to_param
    address
  end

  def all_signer_key_pairs
    signers.map(&:key_pair) + [key_pair]
  end
  memoize :all_signer_key_pairs

  def key_pair
    Stellar::KeyPair.from_address(accountid)
  end

  def balances
    [].tap do |balances|
      balances << {asset: {type: :native}, balance: self.balance}

      trust_lines.each do |tl|
        balances << {
          asset: {type: tl.asset_type_s, issuer: tl.issuer, code: tl.asset_code},
          balance:  tl.balance,
          limit:    tl.tlimit
        }
      end
    end
  end
  memoize :balances

end
