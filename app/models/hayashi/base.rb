class Hayashi::Base < ActiveRecord::Base
  include Memoizes

  self.abstract_class = true
  establish_connection :hayashi
  after_initialize :readonly!

end