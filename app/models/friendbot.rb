# 
# Friendbot is your friendly neighborhood stellar faucet.  It will
# sign and send transactions at the request of anyone, when given a secret seed.
# 
# NOTE: This functionality should not remain in within horizon.  We're including
# it here because the it's a simpler implementation. 
# 
class Friendbot
  include Celluloid

  def self.boot
    puts "seeing if we should boot friendbot"
    if ENV["FRIENDBOT_SECRET"].present?
      puts "booting friendbot"

      supervise_as :friendbot, ENV["FRIENDBOT_SECRET"]
    end
  end

  def self.terminate
    Celluloid::Actor[:friendbot].terminate if Celluloid::Actor[:friendbot]
  end

  def self.available?
    !Celluloid::Actor[:friendbot].nil?
  end

  def self.pay(address)
    Celluloid::Actor[:friendbot].pay(address)
  end

  def initialize(seed)
    @keypair = Stellar::KeyPair.from_seed seed
  end

  def pay(address)
    refresh_sequence_number if @sequence.blank?

    destination = Stellar::KeyPair.from_address address

    tx = Stellar::Transaction.payment({
      account:     @keypair,
      destination: destination,
      sequence:    @sequence + 1,
      amount:      [:native, 100_000000]
    })

    hex = tx.to_envelope(@keypair).to_xdr(:hex)

    tx_sub = TransactionSubmission.new(hex)
    tx_sub.process

    if tx_sub.received?
      @sequence += 1
    else
      @sequence = nil # reset the sequence so we reload the next payment
    end

    tx_sub    
  end

  private
  def refresh_sequence_number
    Hayashi::Account.connection_pool.with_connection do 
      account = Hayashi::Account.where(accountid: @keypair.address).first

      raise "invalid friendbot seed: account not found" if account.blank?

      @sequence = account.sequence
    end
  end
end