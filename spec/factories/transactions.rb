FactoryGirl.define do

  factory :payment, class: Stellar::Transaction do
    account                 factory: :master_key_pair
    destination             factory: :key_pair
    sequence(:sequence, 1)  {|n| n }
    amount                  [:native, 25_000_000]

    initialize_with do 
      Stellar::Transaction.payment({
        account:     account,
        destination: destination,
        sequence:    sequence,
        amount:      amount
      })
    end

    skip_create
  end

end