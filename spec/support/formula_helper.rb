module FormulaHelper
  def dentaku_key_encode(key)
    DentakuKeyEncoder.encode(key)
  end

  def dentaku_key_decode(key)
    DentakuKeyEncoder.decode(key)
  end
end
