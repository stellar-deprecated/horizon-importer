class RootSerializer < ApplicationSerializer
  adapter Oat::Adapters::HAL

  schema do
    link :accounts,     href: "/accounts/{address}", templated: true
    link :transactions, href: "/transactions{?order}{?limit}{?after}{?before}"
    link :metrics,      href: "/metrics"
  end
end