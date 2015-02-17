# 
# The instrumentation module provides a mechanism to simply
# instrument operations on the including class.  It makes available
# and `instrument` class method which you can use to mark certain methods
# as instrumented.  Any calls to that method will be measured with a timer
# and will be reporting into the overall metrics system.
# 
# NOTE:  instrumentations can be defined prior to the actual method being defined.
# we will appropriately create the method chain at the moment of method definition
# if needed.
# 
module Instrumentation
  extend ActiveSupport::Concern

  included do |base|
    cattr_accessor :instrumented_methods
    self.instrumented_methods = {}

    delegate :instrument_for, to: :class
  end

  module ClassMethods
    def instrument(*args)
      options = args.extract_options!

      args.each do |method_name|
        add_instrumentation(method_name, options)        
        create_instrumented_method(method_name, options) if method_exists?(method_name)
      end
    end

    def instrument_for(method_name)
      timer_name = "#{name}##{method_name}"
      Metriks.timer(timer_name)
    end


    def method_added(method_name)
      # short circuits when we are prior the `included` block having run
      return unless respond_to?(:instrumented_methods)
      return unless instrumented_methods.is_a?(Hash)

      options = self.instrumented_methods[method_name]
      return if options.nil?

      create_instrumented_method(method_name, options)
    end

    private
    def add_instrumentation(method_name, options={})
      self.instrumented_methods = self.instrumented_methods.merge(method_name => options)
    end

    def create_instrumented_method(method_name, options={})
      raise ArgumentError, "Invalid method_name: #{method_name.inspect}" unless method_name.is_a?(Symbol)
      instrumented_name = :"#{method_name}_with_instrumentation"

      return if method_exists?(instrumented_name)

      define_method instrumented_name do |*args, &block|
        instrument_for(method_name).time do
          __send__ :"#{method_name}_without_instrumentation", *args, &block
        end
      end

      alias_method_chain method_name, :instrumentation
    end

    def method_exists?(method_name)
      method_defined?(method_name) || private_method_defined?(method_name)
    end
  end
end