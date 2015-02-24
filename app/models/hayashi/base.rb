class Hayashi::Base < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :hayashi
  after_initialize :readonly!

end