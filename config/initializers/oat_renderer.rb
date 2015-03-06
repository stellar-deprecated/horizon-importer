require 'oat/adapters/hal'

module OatRenderer

  def render(controller, obj, options)
    serializer_klass = options[:serializer] || serializer_for(obj)
    serializer = serializer_klass.new(obj, controller:controller)
  end

  def serializer_for(obj)
    return obj.to_oat_serializer if obj.respond_to?(:to_oat_serializer)

    potential_serializer = "#{obj.class.name}Serializer"
    potential_serializer.constantize
  end

  extend self
end

ActionController::Renderers.add :oat do |obj, options|
  render({json: OatRenderer.render(self, obj, options)}, options)
end