# @blueprint
#   ```markdown
#   ## Account [/accounts/{id}]
#   A single account
# 
#   ```
class AccountsController < ApplicationController


  def show
    @account = Hayashi::Account.where(accountid: params[:id]).first

    head :missing unless @account.present?
  end
end
