class AccessDeniedError < ApplicationError

  def to_problem
    {
      type: "access_denied",
      title: "Access Denied",
      status: :forbidden
    }
  end

end