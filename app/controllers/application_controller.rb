class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from Exception, with: :render_error

  private
  def render_error(err)
    self.response_body = nil
    render(problem:err)
  end
end
