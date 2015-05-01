
# 
# A TotalOrderId expressed the total order of Ledgers, Transactions and 
# Operations.  
# 
# Operations within the stellar network have a total order, expressed by three
# pieces of information:  the ledger sequence the operation was validated in,
# the order which the operation's containing transaction was applied in 
# that ledger, and the index of the operation within that parent transaction.
# 
# We express this order by packing those three pieces of information into a
# single signed 64-bit number (we used a signed number for SQL compatibility).
# 
# The follow diagram shows this format:
# 
#    0                   1                   2                   3        
#    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1      
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+     
#   |                    Ledger Sequence Number                     |     
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+     
#   |     Transaction Application Order     |       Op Index        |     
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+   
# 
# By component:
# 
# Ledger Sequence: 32-bits
# 
#   A complete ledger sequence number in which the operation was validated.
# 
#   Expressed in network byte order.
# 
# Transaction Application Order: 20-bits
# 
#   The order that the transaction was applied within the ledger it was 
#   validated.  Accommodates up to 1,048,575 transactions in a single ledger.
# 
#   Expressed in network byte order.
# 
# Operation Index: 10-bits
# 
#   The index of the operation within its parent transaction. Accommodates up 
#   to 4095 operations per transaction.
# 
#   Expressed in network byte order.
# 
# ----
# 
# Note: API Clients should not be interpreting this value.  We will use it
# as an opaque paging token that clients can parrot back to us after having read
# it within a resource to page from the represented position in time.  
# 
# Note: This does not uniquely identify an object.  Given a ledger, it will 
# share its id with its first transaction and the first operation of that 
# transaction as well.  Given that this ID is only meant for ordering within a
# single type of object, the sharing of ids across object types seems 
# acceptable.
#   
# 
module TotalOrderId
  LEDGER_MAX = 2**32-1
  TX_PRECISION = 20
  OP_PRECISION = 12
  TX_MASK = (1 << TX_PRECISION) - 1
  TX_SHIFT = 32 - TX_PRECISION
  OP_MASK = (1 << OP_PRECISION) - 1

  attr_reader :value

  def self.make(ledger, tx=0, op=0)
    if op > OP_MASK
      raise ArgumentError, "op too large: #{op}, max allowed: #{OP_MASK}"
    end

    if tx > TX_MASK
      raise ArgumentError, "tx too large: #{tx}, max allowed: #{TX_MASK}"
    end

    if ledger > LEDGER_MAX
      raise ArgumentError, "ledger too large: #{ledger}, max allowed: #{LEDGER_MAX}"
    end

    # combine tx and op together, where tx is the high 20-bits
    # and op is the low 12-bits
    txop = ((tx & TX_MASK) << TX_SHIFT) | (op & OP_MASK)
    
    # pack ledger and txop together, each as
    # 32-bits in network byte order ("NN"), then extract
    # the combined 64-bits in network byte order ("Q>").
    [ledger, txop].pack("NN").unpack("Q>").first
  end
end


  
                                                                         
                                                                         
                                                                         
                                                                         
                                                                         
                                                                         
                                                                         
                                                                         
