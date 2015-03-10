class Hayashi::Account < Hayashi::Base
  self.table_name  = "accounts"
  self.primary_key = "accountid"
  
  has_many :signers,     class_name: "Hayashi::Signer",    foreign_key: [:accountid]
  has_many :trust_lines, class_name: "Hayashi::TrustLine", foreign_key: [:accountid]

  alias_attribute :sequence, :seqnum
  alias_attribute :address,  :accountid

  def all_signer_key_pairs
    signers.map(&:key_pair) + [key_pair]
  end
  memoize :all_signer_key_pairs

  def key_pair
    Stellar::KeyPair.from_address(accountid)
  end

  def balances
    [].tap do |balances|
      balances << {currency: {type: :native}, balance: self.balance}

      trust_lines.each do |tl|
        balances << {
          currency: {type: :iso4217, issuer: tl.issuer, code: tl.currency_code},
          balance:  tl.balance,
          limit:    tl.limit
        }
      end
    end
  end
  memoize :balances

end
