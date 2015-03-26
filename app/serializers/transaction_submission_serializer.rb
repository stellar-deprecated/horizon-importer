class TransactionSubmissionSerializer < ApplicationSerializer

  schema do
    
    property :hash,    item.transaction_hash

    property :result,            item.result
    property :submission_result, item.submission_result

    if item.history_transaction.present?
      link :transaction, href: "/transactions/#{item.transaction_hash}"
    end

  end
end