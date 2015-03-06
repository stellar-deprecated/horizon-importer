# @blueprint
#   ```markdown
#   ## Account [/accounts/{id}]
#   A single account
# 
#   ```
class AccountsController < ApplicationController


  def show
    @account = Hayashi::Account.where(accountid: params[:id]).first

    render problem: :not_found unless @account.present?
  end
end
