module ActiveAdmin
  module ItemsHelper
    def render_formula_with_bubbles(formula)
      # rubocop:disable Rails/OutputSafety
      formula.gsub(DentakuKeyEncoder::VARIABLE_REGEX) { |dentaku_var| template_bubble_tag(DentakuKeyEncoder.decode(dentaku_var), dentaku_var) }.html_safe
      # rubocop:enable Rails/OutputSafety
    end

    def template_bubble_tag(value, param_id)
      "<span class='formula-bubble' contenteditable='false' data-param-id='#{param_id}'>#{value}</span>"
    end
  end
end
