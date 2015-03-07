# 
# Represents a "find by id" query with multiple ids.  An instance
# can be serialized with Oat for direct rendering to API client
# 
class MultiFind
  extend Memoist


  # 
  # Created a new MultiFind
  # 
  # @param scope [ActiveRecord::Scope] The scope to find from
  # @param ids [Array<Object>] An array of id objects to query
  # 
  def initialize(scope, ids)
    @scope = scope
    @ids   = ids
  end

  # 
  # Returns true if any of the ids were found, false otherwise
  # 
  # @return [Boolean]
  def present?
    results.any?
  end

  # 
  # Returns a hash mapping ids to result objects (or nil if the id was not found)
  # 
  # @return [Hash] The results, indexed by id
  def results_h
    empties = @ids.zip([nil]).to_h
    results.index_by(&:id).reverse_merge(empties)
  end
  memoize :results_h

  # 
  # A flat array of results objects found
  # 
  # @return [Array] the results
  def results
    @scope.where(@scope.primary_key => @ids).to_a
  end
  memoize :results
end