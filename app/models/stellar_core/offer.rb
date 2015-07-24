class StellarCore::Offer < StellarCore::Base
  self.table_name  = "offers"
  self.primary_key = "offerid"

  scope :buying, -> (c) { asset_filter("buying", c) }
  scope :selling, -> (c) { asset_filter("selling", c) }

  ## WIP
  def self.find_path(source, destination, amount_needed)
    results = []
    visited = {}

    fn = -> (depth, path, amount_needed) {
      break if depth > 4

      current = path.last
      visited[current] = true

      # get outbound edges from current
      candidates = selling(current)

      candidates.each do |offer|
        next if visited[offer.buying] == true
        #TODO: check we have enough amount

        next_path = path + [offer.buying]

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


  def self.asset_filter(prefix, a)
    by_type = where({"#{prefix}assettype" => a.type.value})

    is_credit = false
    is_credit ||= a.type == Stellar::AssetType.asset_type_credit_alphanum4
    is_credit ||= a.type == Stellar::AssetType.asset_type_credit_alphanum12

    if is_credit
      by_type.where({
        "#{prefix}issuer"    => Stellar::Convert.pk_to_address(a.issuer),
        "#{prefix}assetcode" => a.code.strip,
      })
    else
      by_type
    end
  end

  def buying
    asset(buyingassettype, buyingassetcode, buyingissuer)
  end

  def selling
    asset(sellingassettype, sellingassetcode, sellingissuer)
  end

  private
  # asset converts the db column values of type/code/issuer into a
  # Stellar::Asset instance
  def asset(type, code, issuer)
    case type
    when Stellar::AssetType.asset_type_native.value
      Stellar::Asset.native
    when Stellar::AssetType.asset_type_credit_alphanum4.value
      issuer = Stellar::KeyPair.from_address(issuer)
      Stellar::Asset.alphanum4(code, issuer)
    when Stellar::AssetType.asset_type_credit_alphanum12.value
      issuer = Stellar::KeyPair.from_address(issuer)
      Stellar::Asset.alphanum12(code, issuer)
    end
  end
end
