class Hayashi::AccountSerializer < ApplicationSerializer
  adapter Oat::Adapters::HAL

  schema do
    type "account"
    link :self, href: context[:controller].account_url(item)

    properties do |props|
      props.id item.id
    end
  end

end