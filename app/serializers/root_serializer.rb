class RootSerializer < ApplicationSerializer
  adapter Oat::Adapters::HAL

  schema do
    link :account,
      href: "/accounts/{address}", 
      templated: true
    link :account_transactions,
      href: "/accounts/{address}/transactions{?after}{?limit}{?order}", 
      templated: true
    link :transaction,
      href: "/transactions/{hash}", 
      templated: true
    link :transactions,
      href: "/transactions{?after}{?limit}{?order}", 
      templated: true
    link :metrics,
      href: "/metrics", 
      templated: true
  end
end