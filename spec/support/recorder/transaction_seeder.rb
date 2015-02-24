module Recorder
  class TransactionSeeder
    def initialize()
      @recipe = IO.read("#{SPEC_ROOT}/fixtures/transactions.rb")
      @accounts = {}
      @transactions = []
      instance_eval @recipe
    end

    def run
      play_transactions

      last_tx = @transactions.last
      last_hash = Convert.to_hex(last_tx.envelope.tx.hash)
      wait_for_transaction last_hash
    end

    def account(name, keypair)
      raise "base name" unless name.is_a?(Symbol)
      raise "base keypair" unless keypair.is_a?(Stellar::KeyPair)
      raise "duplicate name: #{name}" if @accounts.has_key?(name)

      @accounts[name] = Account.new(name, keypair)
    end

    def payment(from, to, amount)
      from, to = @accounts.values_at(from, to)

      envelope = Stellar::Transaction.payment({
        account:     from.keypair,
        destination: to.keypair,
        sequence:    from.next_sequence,
        amount:      amount
      }).to_envelope(from.keypair)

      @transactions.push Transaction.new(from, envelope)
    end

    def play_transactions
      VCR.turned_off do
        WebMock.allow_net_connect!
        @transactions.each do |tx|
          wait_for_account tx.account.keypair.address
          $stellard.get("tx", blob: tx.envelope.to_xdr(:hex))
        end
        WebMock.disable_net_connect!
      end
    end

    private
    def wait_for_account(account, timeout=5.seconds)
      wait_for(timeout){ Hayashi::Account.where(accountid: account).any?  }
    end

    def wait_for_transaction(hash, timeout=5.seconds)
      wait_for(timeout){ Hayashi::Transaction.where(txid: hash).any?  }
    end

    def wait_for(timeout)
      Timeout.timeout(timeout) do
        loop do
          break if yield
          sleep 0.01 # wait atleast 10ms
        end
      end
    end
  end

  Account = Struct.new(:name, :keypair) do
    def next_sequence
      @seq ||= 0
      @seq += 1
    end
  end

  Transaction = Struct.new(:account, :envelope)
end