class FindBatchSerializer < ApplicationSerializer
  adapter Oat::Adapters::HAL

  schema do
    type "find_batch"

    item.results_h.each do |key, value|
      entity [key], value, context[:child_serializer]
    end
  end
end