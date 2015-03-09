# 
# This validator performs deeper validation of a PendingTransaction.  Any
# validations beyond "Is this present" or "Is this numeric", etc. should end
# up in this validator.
# 
# Presently, it:
# 
# - validates the sending account is a valid base58check encoded account_id
# - validates the sending account is known (i.e. in the ledger)
# - validates the sending accounts sequence number is <= the transactions sequence
# 
# 
class TransactionPlausibilityValidator < ActiveModel::Validator
  def validate(pending_tx)
    return if pending_tx.tx_envelope.blank?
    env = pending_tx.parsed_envelope

    if env.nil?
      pending_tx.errors[:tx_envelope] = "is not parseable"
    end

    if invalid_sending_address?(pending_tx)
      pending_tx.errors[:sending_address] = "is not base58 encoded"
    end

    account = pending_tx.sending_account

    # TODO: perhaps we shouldn't fail the transaction from unknown accounts where
    # the transaction sequence is 1 (i.e. we may have simply closed the ledger
    # that funds the account)
    if account.blank?
      pending_tx.errors[:sending_address] = "is unknown"
    elsif account.sequence > pending_tx.sending_sequence
      pending_tx.errors[:sending_sequence] = "is greater than account's sequence"
    end

    if env && !env.signed_correctly?(*account.all_signer_key_pairs)
      pending_tx.errors[:tx_envelope] = "is not signed correctly"
    end   
  end

  def invalid_sending_address?(pending_tx)
    # TODO: exception for control is no bueno
    # update stellar-core to provide non-throwing variants
    Convert.base58.check_decode(:account_id, pending_tx.sending_address)
    false
  rescue ArgumentError
    true
  end
end