class WelcomeController < ApplicationController
  def index
    render oat: RootSerializer.new({})
  end

  def not_found
    render problem: :not_found
  end
end
