class StellarCore::LedgerHeader < StellarCore::Base
  self.table_name  = "ledgerheaders"
  self.primary_key = "ledgerhash"

  alias_attribute :sequence, :ledgerseq

  has_many :transactions, {
    class_name: "StellarCore::Transaction", 
    foreign_key: :ledgerseq, 
    primary_key: :ledgerseq,
  }

  scope :latest, ->(){ order("ledgerseq DESC").first }
  
  def self.at_sequence(sequence)
    where(ledgerseq:sequence).first
  end
end
