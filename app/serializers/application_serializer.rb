class ApplicationSerializer < Oat::Serializer
  adapter Oat::Adapters::HAL

  def self.as_find_batch(find_batch)
    FindBatchSerializer.new(find_batch, child_serializer: self)
  end

  def self.as_page(page)
    CollectionPageSerializer.new(page, child_serializer: self)
  end
end