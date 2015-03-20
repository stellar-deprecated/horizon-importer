module Pageable
  extend ActiveSupport::Concern

  def to_paging_token
    raise NotImplementedError, 'A pageable object must implement `to_paging_token`'
  end
end