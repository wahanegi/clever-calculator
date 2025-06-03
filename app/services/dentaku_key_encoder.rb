module DentakuKeyEncoder
  def self.encode(label)
    hex = label.unpack1("H*")
    "var_#{hex}_end"
  end

  def self.decode(encoded_key)
    hex = encoded_key.sub(/^var_/, '').sub(/_end$/, '')
    [hex].pack("H*")
  rescue ArgumentError
    raise ArgumentError, "Invalid encoded Dentaku key format"
  end
end
