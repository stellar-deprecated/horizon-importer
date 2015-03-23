require 'oat/adapters/hal'

module OatRenderer

  def render(controller, obj, options)
    serializer =  if obj.is_a? Oat::Serializer
                    obj
                  else
                    serializer_klass = options[:serializer_klass] || serializer_klass_for(obj)
                    serializer_klass.new(obj)
                  end

    serializer.context[:controller] = controller
    serializer.context[:original_url] = controller.request.original_url
    serializer
  end

  def serializer_klass_for(obj)
    potential_serializer = "#{obj.class.name}Serializer"
    potential_serializer.constantize
  end

  extend self
end

ActionController::Renderers.add :oat do |obj, options|
  render({json: OatRenderer.render(self, obj, options)}, options)
end