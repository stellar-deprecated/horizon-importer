class WelcomeController < ApplicationController
  def index
    render oat: RootSerializer.new({})
  end

  def friendbot
    if $friendbot
      $friendbot.pay(params[:addr])
      head :created
    else
      render problem: :not_found
    end
  end

  def not_found
    render problem: :not_found
  end
end
