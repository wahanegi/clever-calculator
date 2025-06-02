class String
  def to_formula_name(id)
    downcase.gsub(/[^a-z0-9\s]/, '').strip.gsub(/\s+/, '_') + "_#{id}"
  end
end
