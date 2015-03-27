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
    tx_sub = TransactionSubmission.new(params[:tx])
    tx_sub.process
    render_submission_response tx_sub
  end

  def friendbot
    if $friendbot
      tx_sub = $friendbot.pay(params[:addr])
      render_submission_response tx_sub
    else
      render problem: :not_found
    end
  end

  private
  def render_submission_response(tx_sub)
    case tx_sub.result
    when :malformed, :failed ;
      render oat:tx_sub, status: :unprocessible_entity
    when :received ;
      render oat:tx_sub, status: :created
    when :already_finished ;
      render oat:tx_sub, status: :ok
    when :connection_failed ;
      render oat:tx_sub, status: :internal_server_error
    else
      raise "Unexpected submission result: #{tx_sub.result}"
    end
  end
end
