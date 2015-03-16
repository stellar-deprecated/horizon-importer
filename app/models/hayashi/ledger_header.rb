class Hayashi::LedgerHeader < Hayashi::Base
  self.table_name  = "ledgerheaders"
  self.primary_key = "ledgerhash"

  has_many :transactions, {
    class_name: "Hayashi::Transaction", 
    foreign_key: :ledgerseq, 
    primary_key: :ledgerseq,
  }
  
  def self.at_sequence(sequence)
    where(ledgerseq:sequence).first
  end
end
