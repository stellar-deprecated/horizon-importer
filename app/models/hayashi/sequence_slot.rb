class Hayashi::SequenceSlot < Hayashi::Base
  self.table_name   = :seqslots
  self.primary_keys = :accountid, :seqslot
  
  belongs_to :account, class_name: "Hayashi::Account", foreign_key: :accountid

  scope :for_slot, ->(slot) { where(seqslot:slot)}

  alias_attribute :slot, :seqslot
  alias_attribute :sequence, :seqnum
end
