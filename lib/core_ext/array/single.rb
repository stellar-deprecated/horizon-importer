
module CoreExt
  module Array
    module Single

      # 
      # Returns the fist element of the receiver Array  if and only if it contains 
      # a single element, 
      # 
      # @return [Object,nil] The first element or nil
      def single
        return first if length == 1
      end
    end
  end
end

Array.include CoreExt::Array::Single