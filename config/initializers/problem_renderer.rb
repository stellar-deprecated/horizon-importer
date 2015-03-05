GENERIC_PROBLEM = {
  type:   'server_error',
  status: :internal_server_error,
  title:  "Internal Server Error",
}

ActionController::Renderers.add :problem do |obj, options|
  # normalize the provided object into a problem hash
  problem = case
            when obj.is_a?(Hash)
              obj
            when obj.respond_to?(:to_problem)
              obj.to_problem
            when Exception
              GENERIC_PROBLEM
            else
              raise ArgumentError, "Cannot convert to problem: #{obj.class.name}" 
            end

  self.content_type ||= "application/problem+json"

  status_code        = Rack::Utils.status_code(problem[:status] || :internal_server_error)
  self.status        = problem[:status] = status_code 
  problem[:instance] = "request://#{request.uuid}"

  # TODO: normalize type to url

  self.response_body = ActiveSupport::JSON.encode(problem)
end