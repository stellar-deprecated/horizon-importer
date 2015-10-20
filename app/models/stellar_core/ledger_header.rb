class StellarCore::LedgerHeader < StellarCore::Base
  self.table_name  = "ledgerheaders"
  self.primary_key = "ledgerhash"

  alias_attribute :sequence, :ledgerseq

  has_many :transactions, -> { order("txindex ASC") }, {
    class_name: "StellarCore::Transaction", 
    foreign_key: :ledgerseq, 
    primary_key: :ledgerseq,
  }

  scope :latest, ->(){ order("ledgerseq DESC").first }
  
  def self.at_sequence(sequence)
    where(ledgerseq:sequence).first
  end


  memoize def xdr
    Stellar::LedgerHeader.from_xdr(self.data, 'base64') 
  end

  delegate :total_coins, to: :xdr
  delegate :fee_pool, to: :xdr
  delegate :base_fee, to: :xdr
  delegate :base_reserve, to: :xdr
  delegate :max_tx_set_size, to: :xdr
end
