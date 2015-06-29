class StellarCore::Offer < StellarCore::Base
  self.table_name  = "offers"
  self.primary_key = "offerid"

  scope :taker_gets, -> (c) { currency_filter("gets", c) }
  scope :taker_pays, -> (c) { currency_filter("pays", c) }

  ## WIP
  def self.find_path(source, destination, amount_needed)
    results = []
    visited = {}

    fn = -> (depth, path, amount_needed) {
      break if depth > 4

      current = path.last
      visited[current] = true

      # get outbound edges from current
      candidates = taker_gets(current)

      candidates.each do |offer|
        next if visited[offer.taker_pays] == true
        #TODO: check we have enough amount

        next_path = path + [offer.taker_pays]

        if next_path.last == source
          results << next_path
        else
          fn.call(depth + 1, next_path, amount_needed)
        end
      end
    }

    # trigger recursive algorithm
    fn.call(0, [destination], amount_needed)

    # trim off the start and end (the path expected by a transaction does note
    # include the start or end)
    results.map do |path|
      path[1...-1]
    end
  end


  def self.currency_filter(prefix, c)
    case c.type
    when Stellar::CurrencyType.currency_type_native
      where({"#{prefix}issuer" => nil})
    when Stellar::CurrencyType.currency_type_alphanum
      ac = c.alpha_num!
      where({
        "#{prefix}issuer"           => Convert.pk_to_address(ac.issuer),
        "#{prefix}alphanumcurrency" => ac.currency_code.strip,
      })
    else
      raise ArgumentError, "unsupported currency type: #{c.type}"
    end
  end

  def taker_pays
    currency(paysalphanumcurrency, paysissuer)
  end

  def taker_gets
    currency(getsalphanumcurrency, getsissuer)
  end

  private
  def currency(alphanumcurrency, issuer)
    if issuer.blank?
      Stellar::Currency.native
    else
      issuer = Stellar::KeyPair.from_address(issuer)
      Stellar::Currency.alphanum(alphanumcurrency, issuer)
    end
  end
end
