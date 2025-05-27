class String
  def to_formula_name
    downcase.gsub(/[^a-z0-9\s]/, '').strip.gsub(/\s+/, '_')
  end
end
