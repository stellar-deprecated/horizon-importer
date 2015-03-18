class TransactionsController < ApplicationController
  def index
    # load what page, etc.

    txs  = History::Transaction.application_order.all
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
