# 
# Rack middleware and helper method to aid in rendering 
# https://tools.ietf.org/html/draft-ietf-appsawg-http-problem-00.txt responses
# 
# 
module ProblemRenderer
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

  CONTENT_TYPE = "application/problem+json".freeze

  # 
  # Renders the problem into a status_code, content_type and body suitable
  # for presenting to an API client
  # 
  # @param obj [Symbol,Hash,Exception,#to_problem] The problem to render
  # @param req [ActionDispath::Request] The current request
  # 
  # @return [Array<Fixnum, String, String>] Returns a 3 element array consisting
  #   of [status_code, content_type, body]
  def render(obj, req)
    problem = case
              when obj.is_a?(Symbol)
                COMMON_PROBLEMS[obj]
              when obj.respond_to?(:to_problem)
                obj.to_problem
              when obj.is_a?(Exception)
                COMMON_PROBLEMS[:generic]
              else
                obj
              end

    problem     = COMMON_PROBLEMS[:generic] unless problem.is_a?(Hash)
    status_code = Rack::Utils.status_code(problem[:status] || :internal_server_error)

    problem = problem.merge({
      status:   status_code,
      instance: "request://#{req.uuid}"
    })

    [status_code, CONTENT_TYPE, ActiveSupport::JSON.encode(problem)]
  end


  def call(env)
    request      = ActionDispatch::Request.new(env)
    exception    = env["action_dispatch.exception"]
    status, content_type, body = render(exception, request)

    headers = {
      'Content-Type' => "#{content_type}; charset=#{ActionDispatch::Response.default_charset}",
      'Content-Length' => body.bytesize.to_s
    }

    [status, headers, [body]]
  end

  extend self
end
