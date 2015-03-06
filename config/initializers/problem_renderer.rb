COMMON_PROBLEMS = {
  generic: {
    type:   'server_error',
    status: :internal_server_error,
    title:  "Internal Server Error",
  },
  not_found: {
    type:    'not_found',
    status:  :not_found,
    title:   "Resource Missing",
  },
}

ActionController::Renderers.add :problem do |obj, options|
  # normalize the provided object into a problem hash
  problem = case
            when obj.is_a?(Symbol)
              COMMON_PROBLEMS[obj]
            when obj.respond_to?(:to_problem)
              obj.to_problem
            when Exception
              COMMON_PROBLEMS[:generic]
            else
              obj
            end

  problem = COMMON_PROBLEMS[:generic] unless problem.is_a?(Hash)

  status_code       = Rack::Utils.status_code(problem[:status] || :internal_server_error)
  self.content_type = "application/problem+json"
  self.status       = status_code 

  problem = problem.merge({
    status:   status_code,
    instance: "request://#{request.uuid}"
  })

  # TODO: normalize type to url

  self.response_body = ActiveSupport::JSON.encode(problem)
end