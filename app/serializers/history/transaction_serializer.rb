class History::TransactionSerializer < ApplicationSerializer
  adapter Oat::Adapters::HAL

  schema do
    type "transaction"
    link :self,    href: context[:controller].transaction_url(item)
    link :account, href: context[:controller].account_url(item.account)
    
    #TODO: link :ledger, href: blah

    property :id,                item.transaction_hash
    property :paging_token,      item.to_paging_token
    property :hash,              item.transaction_hash
    property :ledger,            item.ledger_sequence
    property :application_order, [item.ledger_sequence, item.application_order]

    map_properties *[
      :account, 
      :account_sequence,
      :max_fee,
      :fee_paid,
      :operation_count,
    ]

    #TODO: property :result_code, item.result_code
    #TODO: property :result_code_s, item.result_code_s
  end
end