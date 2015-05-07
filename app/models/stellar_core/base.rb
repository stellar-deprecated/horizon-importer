class StellarCore::Base < ActiveRecord::Base
  include Memoizes

  self.abstract_class = true
  establish_connection :stellar_core
  after_initialize :readonly!

end