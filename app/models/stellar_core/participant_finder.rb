module StellarCore
  module ParticipantFinder

    def from_tx(tx)
      [
        tx.source_account,
        from_meta(tx.meta, tx.fee_meta),
        from_operations(tx.operations),
      ].flatten.uniq
    end

    def from_meta(meta, fee_meta)
      results = []
      all_changes = meta.operations!.flat_map(&:changes)
      all_changes += fee_meta.changes
      all_changes.each do |change|
        data = case change.type
               when Stellar::LedgerEntryChangeType.ledger_entry_created
                 change.created!.data
               when Stellar::LedgerEntryChangeType.ledger_entry_updated
                 change.updated!.data
               when Stellar::LedgerEntryChangeType.ledger_entry_removed
                 change.removed!
               when Stellar::LedgerEntryChangeType.ledger_entry_state
                 next # "state" entries are not needed to calculate participants
               else
                 raise "Unknown ledger entry change type: #{change.type}"
               end


        next unless data.type == Stellar::LedgerEntryType.account

        results << data.account!.account_id
      end

      results.uniq
    end

    def from_operations(ops)
      ops.flat_map{|op| from_operation(op)}
    end

    # from_operation returns the account ids for the _direct_ participants of
    # `op`.  This list is not exhaustive;  For example, a participant whose
    # offer is taken to fulfill a path payment will not be returned by this
    # method.
    def from_operation(op)
      results = []
      if op.source_account.present?
        results << op.source_account
      end

      case op.body.type
      when Stellar::OperationType.create_account;
        results << op.body.value.destination
      when Stellar::OperationType.payment;
        results << op.body.value.destination
      when Stellar::OperationType.path_payment;
        results << op.body.value.destination
      when Stellar::OperationType.manage_offer;
        # the only direct participant is the source_account
      when Stellar::OperationType.create_passive_offer;
        # the only direct participant is the source_account
      when Stellar::OperationType.set_options;
        # the only direct participant is the source_account
      when Stellar::OperationType.change_trust;
        # the only direct participant is the source_account
      when Stellar::OperationType.allow_trust;
        results << op.body.value.trustor
      when Stellar::OperationType.account_merge;
        op.body.value
      when Stellar::OperationType.inflation;
        # the only direct participant is the source_account
      else
        raise ArgumentError, "Unknown operation type: #{op.body.type}"
      end

      return results
    end

    extend self
  end
end
