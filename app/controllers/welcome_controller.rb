class WelcomeController < ApplicationController
  def index
    render oat: RootSerializer.new({})
  end
end
