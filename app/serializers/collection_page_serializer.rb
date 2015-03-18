class CollectionPageSerializer < ApplicationSerializer
  adapter Oat::Adapters::HAL

  schema do

    # TODO: add links to next, prev, first, last page
    # TODO: add links to reverse order

    meta :total_count, item.total_count

    entities ["records"], item.records, context[:child_serializer]
    # item.records.each_with_index do |record, i|
    # end
  end
end