class CollectionPageSerializer < ApplicationSerializer
  adapter Oat::Adapters::HAL

  schema do
    if item.records.any?
      link :next, href: context[:controller].url_for(after: item.end_token, order:item.order, limit:item.limit)
    end

    entities ["records"], item.records, context[:child_serializer]
  end
end