# @blueprint
#   ```markdown
#   ## Account [/accounts/{id}]
#   A single account
# 
#   ```
class AccountsController < ApplicationController


  def show
    @account = Hayashi::Account.where(accountid: params[:id]).first

    if @account.present?
      render oat: @account
    else
      render problem: :not_found
    end
  end
end
