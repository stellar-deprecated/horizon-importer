# 
# Represents a page of results loaded from a database.
# 
# TODO: Give it some features
# 
class CollectionPage

  attr_reader :records

  def total_count
    records.size # TODO
  end

  def initialize(records)
    @records = records
  end

end