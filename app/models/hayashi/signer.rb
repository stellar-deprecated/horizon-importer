class Hayashi::Signer < Hayashi::Base
  self.table_name   = :signers
  self.primary_keys = :accountid, :publickey
  
  belongs_to :account, class_name: "Hayashi::Account", foreign_key: :accountid

  def key_pair
    Stellar::KeyPair.from_address(publickey)
  end
end
