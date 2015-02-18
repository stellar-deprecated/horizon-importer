class Hayashi::Base < ActiveRecord::Base
  self.abstract_class = true
  
  after_initialize :readonly!

end