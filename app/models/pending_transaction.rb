class PendingTransaction < ActiveRecord::Base
  include AASM
  
  enum state: { 
    pending:   0, 
    submitted: 1,
    confirmed: 2,
    dead:      3,
    errored:   4,
  }



end
