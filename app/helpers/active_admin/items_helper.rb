module ActiveAdmin
  module ItemsHelper
    OPERATOR_REGEX = %r{[+\-*/()]}
    NUMBER_REGEX = /(?<![a-zA-Z0-9_])\d+(?![a-zA-Z0-9_])/
    VARIABLE_REGEX = /var_[0-9a-fA-F]+_end/

    def formula_preview_html(formula)
      # rubocop:disable Rails/OutputSafety
      formula
        .gsub(OPERATOR_REGEX) { |operator| template_preview_bubble(operator, "operator") }
        .gsub(NUMBER_REGEX) { |custom_value| template_preview_bubble(custom_value, "custom-value") }
        .gsub(VARIABLE_REGEX) { |dentaku_var| template_preview_bubble(DentakuKeyEncoder.decode(dentaku_var), "param") }
        .html_safe
      # rubocop:enable Rails/OutputSafety
    end

    def formula_builder_html(formula)
      # rubocop:disable Rails/OutputSafety
      formula
        .gsub(OPERATOR_REGEX) { |operator| template_bubble(template_operator(operator), "operator") }
        .gsub(NUMBER_REGEX) { |custom_value| template_bubble(template_custom_value(custom_value), "custom-value") }
        .gsub(VARIABLE_REGEX) { |dentaku_var| template_bubble(template_param(dentaku_var, DentakuKeyEncoder.decode(dentaku_var)), "param") }
        .html_safe
      # rubocop:enable Rails/OutputSafety
    end

    private

    def template_preview_bubble(data, type)
      "<div class=\"formula-preview-bubble formula-preview-#{type}\">#{data}</div>"
    end

    def template_bubble(data, type)
      "<div class=\"formula-display-bubble formula-display-#{type}\" data-type=\"#{type}\">#{data}#{template_controls}</div>"
    end

    def template_param(param, value)
      "<span data-param=\"#{param}\">#{value}</span>"
    end

    def template_operator(operator)
      "<span data-operator=\"#{operator}\">#{operator}</span>"
    end

    def template_custom_value(number)
      "<input type='number' name='custom_value' min='0' value='#{number}' />"
    end

    def template_controls
      <<~HTML
        <div class="formula-display-controls">
          <button class="formula-display-controls-move-left-button">&lt;</button>
          <button class="formula-display-controls-remove-button">x</button>
          <button class="formula-display-controls-move-right-button" title="Move right">&gt;</button>
        </div>
      HTML
    end
  end
end
