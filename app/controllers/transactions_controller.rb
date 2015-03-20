class TransactionsController < ApplicationController

  DEFAULT_PAGE_SIZE = 10
  MAX_PAGE_SIZE     = 100

  def index
    # TODO: load what page, etc.
    

    # process limit
    limit = Integer(params[:limit]) if params[:limit].present?
    limit ||= DEFAULT_PAGE_SIZE
    limit = MAX_PAGE_SIZE if limit > MAX_PAGE_SIZE
    limit = 1 if limit < 1

    txs  = History::Transaction.
      application_order.
      limit(limit)

    page = CollectionPage.new(txs)

    render oat: History::TransactionSerializer.as_page(page)
  end

  def show
    tx = History::Transaction.where(transaction_hash: params[:id]).first

    if tx.present?
      render oat: tx
    else
      render problem: :not_found
    end
  end
end
