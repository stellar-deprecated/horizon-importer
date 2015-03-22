class RootSerializer < ApplicationSerializer
  adapter Oat::Adapters::HAL

  schema do
    link :accounts,     href: "/accounts/{address}", templated: true
    link :transactions, href: "/transactions"
    link :metrics,      href: "/metrics"
  end
end