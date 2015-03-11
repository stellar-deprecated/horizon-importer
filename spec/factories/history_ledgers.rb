FactoryGirl.define do
  factory :history_ledger, :class => 'History::Ledger' do
    sequence(:sequence, 1)

    ledger_hash       { Digest::SHA256.hexdigest(sequence.to_s)  }
    transaction_count 0
    operation_count   0
    closed_at         { Time.now }

    after(:build) do |l| 
      prev_ledger = History::Ledger.where(sequence:l.sequence - 1).first
      l.previous_ledger_hash = prev_ledger.try(:ledger_hash)
    end
  end
end
