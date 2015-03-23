# 
# Represents a page of results loaded from a database.
# 
# TODO: Give it some features
# 
class CollectionPage

  attr_reader :records, :order, :limit


  def initialize(records, order, limit)

    unless records.all?{|r| r.is_a?(Pageable)}
      raise ArgumentError, "all records provided to CollectionPage must include Pageable"
    end

    @records = records
    @order   = order
    @limit   = limit
  end

  def start_token
    @records.first.to_paging_token
  end

  def end_token
    @records.last.to_paging_token
  end
end