
ActionController::Renderers.add :problem do |obj, options|
  status, content_type, body = ProblemRenderer.render(obj, request)

 
  self.content_type  = content_type
  self.status        = status
  self.response_body = body
end