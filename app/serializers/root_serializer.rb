class RootSerializer < ApplicationSerializer
  adapter Oat::Adapters::HAL

  schema do
    link :accounts,
      href: "/accounts/{address}", 
      templated: true
    link :transactions,
      href: "/transactions{?order}{?limit}{?after}{?before}", 
      templated: true
    link :account_transactions,
      href: "/accounts/{address}/transactions{?order}{?limit}{?after}{?before}", 
      templated: true
    link :metrics,
      href: "/metrics", 
      templated: true
  end
end