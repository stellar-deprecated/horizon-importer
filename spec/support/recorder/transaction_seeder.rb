module Recorder
  class TransactionSeeder
    DEFAULT_TIMEOUT=10.seconds
    
    def initialize()
      @recipe = IO.read("#{SPEC_ROOT}/fixtures/transactions.rb")
      @accounts = {}
      @transactions = []
    end

    def run
      play_transactions

      last_tx = @transactions.last[:tx]
      last_hash = Convert.to_hex(last_tx.envelope.tx.hash)
      puts "done playing txs, waiting for last hash:#{last_hash}"
      wait_for_transaction last_hash
    end

    def account(name, keypair)
      raise "base name" unless name.is_a?(Symbol)
      raise "base keypair" unless keypair.is_a?(Stellar::KeyPair)
      raise "duplicate name: #{name}" if @accounts.has_key?(name)

      @accounts[name] = Account.new(self, name, keypair)
    end

    def sequence_for(name)
      account = @accounts[name]
      raise "unknown account: #{name}" if account.blank?
      hayashi_account = wait_for_account account.keypair.address
      hayashi_account.seqnum
    end

    def payment(from, to, amount)
      from, to = @accounts.values_at(from, to)

      envelope = Stellar::Transaction.payment({
        account:     from.keypair,
        destination: to.keypair,
        sequence:    from.next_sequence,
        amount:      amount
      }).to_envelope(from.keypair)

      submit_transaction Transaction.new(from, envelope)
    end

    def play_transactions
      VCR.turned_off do
        WebMock.allow_net_connect!
        instance_eval @recipe
        WebMock.disable_net_connect!
      end
    end

    private
    def submit_transaction(tx)
      begin
        wait_for_account tx.account.keypair.address
        response  = $stellard.get("tx", blob: tx.envelope.to_xdr(:hex))
        raw       = [response.body["result"]].pack("H*")
        tx_result = Stellar::TransactionResult.from_xdr(raw)

        # TODO: break if a non-success response is returned

        @transactions << {tx: tx, result: tx_result}
      rescue
        puts "Error when playing tx: #{tx.inspect}"
        raise
      end
    end


    def wait_for_account(account, timeout=DEFAULT_TIMEOUT)
      wait_for(timeout){ Hayashi::Account.where(accountid: account).first  }
    end

    def wait_for_transaction(hash, timeout=DEFAULT_TIMEOUT)
      wait_for(timeout){ Hayashi::Transaction.where(txid: hash).first  }
    end

    def wait_for(timeout)
      Timeout.timeout(timeout) do
        loop do
          result = yield
          break result if result.present?
          sleep 0.01 # wait atleast 10ms
        end
      end
    end
  end

  Account = Struct.new(:seeder, :name, :keypair) do
    def next_sequence
      @seq ||= self.seeder.sequence_for(name)
      @seq += 1
    end
  end

  Transaction = Struct.new(:account, :envelope)
end