class ItemFormulaSyntaxValidator < ActiveModel::Validator
  def validate(record)
    return if record.calculation_formula.blank?

    check_all_formula_parameters_present(record)
    check_allowed_parameters(record)
    check_operator_placement(record)
    validate_formula_syntax(record)
  end

  private

  def requires_calculation_formula?(record)
    record.is_fixed || record.is_open || record.is_selectable_options
  end

  def check_all_formula_parameters_present(record)
    missing_parameters = record.formula_parameters.reject do |param|
      record.calculation_formula.match?(/\b#{Regexp.escape(param)}\b/)
    end

    return if missing_parameters.empty?

    record.errors.add(:calculation_formula, "is missing parameters: #{missing_parameters.join(', ')}")
  end

  def check_allowed_parameters(record)
    operators = %w[+ - * / % ( )]
    tokens = record.calculation_formula.scan(%r{\d+\.\d+|\d+|[A-Za-z_]\w*|[+\-*/%()\]]})

    invalid_parameters = tokens.reject do |token|
      token.match?(/\A\d+(\.\d+)?\z/) ||
        operators.include?(token) ||
        record.formula_parameters.include?(token)
    end
    return if invalid_parameters.empty?

    record.errors.add(:calculation_formula, "contains invalid parameters: #{invalid_parameters.uniq.join(', ')}")
  end

  def check_operator_placement(record)
    if record.calculation_formula.match?(%r{\A\s*[+\-*/%]})
      record.errors.add(:calculation_formula, "cannot start with a mathematical operator")
    end
    return unless record.calculation_formula.match?(%r{[+\-*/%]\s*\z})

    record.errors.add(:calculation_formula, "cannot end with a mathematical operator")
  end

  def validate_formula_syntax(record)
    calculator = Dentaku::Calculator.new
    calculator.dependencies(record.calculation_formula)
  rescue Dentaku::ParseError => e
    handle_parse_error(record, e)
  rescue StandardError => e
    record.errors.add(:calculation_formula, "could not validate formula: #{e.message}")
  end

  def handle_parse_error(record, error)
    case error.message
    when /Undefined function/
      record.errors.add(:calculation_formula, "references an undefined function. Please review formula structure.")
    when /too few operands/
      record.errors.add(:calculation_formula, "has missing operands. Ensure the correct number of arguments.")
    when /has too many/
      record.errors.add(:calculation_formula, "has extra operands. Ensure the correct number of arguments.")
    else
      record.errors.add(:calculation_formula, "has a syntax error: #{error.message}")
    end
  end
end
