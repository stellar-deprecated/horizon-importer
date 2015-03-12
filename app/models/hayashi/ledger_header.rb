class Hayashi::LedgerHeader < Hayashi::Base
  self.table_name  = "ledgerheaders"
  self.primary_key = "ledgerhash"
  
  def self.at_sequence(sequence)
    where(ledgerseq:sequence).first
  end
end
