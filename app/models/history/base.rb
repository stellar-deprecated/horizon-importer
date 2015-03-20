class History::Base < ActiveRecord::Base
  include Memoizes

  self.abstract_class    = true
  self.table_name_prefix = "history_"
end