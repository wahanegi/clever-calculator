module DentakuKeyEncoder
  VARIABLE_REGEX = /var_[0-9a-fA-F]+_end/

  def self.encode(label)
    hex = label.unpack1("H*")
    "var_#{hex}_end"
  end

  def self.decode(encoded_key)
    return encoded_key unless variable?(encoded_key)

    hex = encoded_key.sub(/^var_/, '').sub(/_end$/, '')
    [hex].pack("H*")
  rescue ArgumentError
    raise ArgumentError, "Invalid encoded Dentaku key format"
  end

  def self.variable?(key)
    VARIABLE_REGEX.match?(key)
  end
end
