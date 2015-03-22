class TransactionsController < ApplicationController

  DEFAULT_PAGE_SIZE = 10
  MAX_PAGE_SIZE     = 100

  def index
    tx_scope = History::Transaction

    #TODO: clean this whole friggin method up

    # process limit
    limit = Integer(params[:limit]) if params[:limit].present?
    limit ||= DEFAULT_PAGE_SIZE
    limit = MAX_PAGE_SIZE if limit > MAX_PAGE_SIZE
    limit = 1 if limit < 1
    tx_scope = tx_scope.limit(limit)

    # process account
    tx_scope = tx_scope.for_account(params[:account_id]) if params[:account_id].present?

    #process order
    order = params[:order].present? ? params[:order] : "asc"

    tx_scope = case order
      when 'asc'
        tx_scope.application_order
      when 'desc'
        tx_scope.application_order.reverse_order
      else
        raise "invalid order #{order}" # TODO: render to a problem
      end

    #process paging
    if params[:after].present?
      tx_scope = case order
        when 'asc'
          tx_scope.after_token(params[:after])
        when 'desc'
          tx_scope.before_token(params[:after])
        else
          raise "invalid order #{order}" # TODO: render to a problem
        end
    end

    page = CollectionPage.new(tx_scope, order, limit)

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

  def create
    tx = PendingTransaction.new(tx_envelope: params[:tx])
    
    if tx.save
      render oat:tx, status: :created
    else
      render problem:tx
    end
  end
end
