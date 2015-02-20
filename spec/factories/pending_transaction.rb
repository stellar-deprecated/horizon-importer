FactoryGirl.define do

  factory :pending_transaction do

    transient do
      transaction{ build(:payment) }     
      key        { build(:master_key_pair) }
    end

    tx_envelope { transaction.to_envelope(key).to_xdr(:hex) }

    # by default, we don't want to be dependent upon data created within hayashi 
    # core for out test suite (or we don't want that dependency at least until 
    # our test suite creates a private hayashi network).  Given that, we avoid
    # the plausibility validator in our test suite, except in specific cases
    # where we have setup the hayashi db correctly
    validate_plausibility false 
  end

end