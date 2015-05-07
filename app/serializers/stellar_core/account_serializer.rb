class StellarCore::AccountSerializer < ApplicationSerializer
  adapter Oat::Adapters::HAL

  schema do
    type "account"
    link :self, 
      href: "/accounts/#{item.to_param}"
    link :transactions, 
      href: "/accounts/#{item.to_param}/transactions{?order}{?limit}{?after}{?before}"

    map_properties :id, :address, :sequence, :balances

  end
end