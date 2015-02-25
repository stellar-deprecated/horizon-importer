module Memoizes
  extend ActiveSupport::Concern

  included do
    extend Memoist
  end

  def reload(*args)
    flush_cache
    super(*args)
  end
end