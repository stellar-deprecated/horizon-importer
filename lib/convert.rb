# 
# Generic format conversion module
# 
module Convert

  def to_hex(string)
    string.unpack("H*").first
  end

  def from_hex(hex_string)
    [hex_string].pack("H*")
  end

  def base58
    Stellar::Util::Base58.stellar
  end

  extend self
end