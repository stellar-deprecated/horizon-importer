class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from StandardError, with: :render_error

  private
  def render_error(err)
    self.response_body = nil # reset the rendering if we had a response body
    render(problem:err)
  end
end
