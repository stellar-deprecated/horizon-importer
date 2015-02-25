class Hayashi::Account < Hayashi::Base
  self.table_name  = "accounts"
  self.primary_key = "accountid"
  
  has_many :signers, class_name: "Hayashi::Signer", foreign_key: [:accountid]

  memoize def all_signer_key_pairs
    signers.map(&:key_pair) + [key_pair]
  end

  def key_pair
    Stellar::KeyPair.from_address(accountid)
  end
end
