class TransactionSubmissionSerializer < ApplicationSerializer

  schema do
    
    property :hash,    item.transaction_hash

    property :result, item.result
    property :error,  item.submission_error

    if item.history_transaction.present?
      link :transaction, href: "/transactions/#{item.transaction_hash}"
    end

  end
end