
module CoreExt
  module Hash
    module MapValues

      def map_values
        each_pair.with_object({}) do |(key, value), result|
          result[key] = yield value, key
        end
      end
      
    end
  end
end

Hash.include CoreExt::Hash::MapValues