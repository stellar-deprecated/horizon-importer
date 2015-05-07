class AccountsController < ApplicationController
  def show
    ids = params[:id].split(",")

    if id = ids.single
      show_single(id)
    else
      show_batch(ids)
    end
  end

  private
  def show_batch(ids)
    accounts = FindBatch.new(StellarCore::Account, ids)

    if accounts.present?
      render oat: StellarCore::AccountSerializer.as_find_batch(accounts)
    else
      render problem: :not_found
    end
  end

  def show_single(id)
    account = StellarCore::Account.where(accountid: params[:id]).first

    if account.present?
      render oat: account
    else
      render problem: :not_found
    end
  end
end
