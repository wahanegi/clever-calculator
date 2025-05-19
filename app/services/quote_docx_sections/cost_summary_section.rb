module QuoteDocxSections
  class CostSummarySection
    include ActionView::Helpers::NumberHelper

    def initialize(docx, colors, grouped_items, quote)
      @docx = docx
      @colors = colors
      @grouped_items = grouped_items
      @quote = quote
    end

    def call
      primary_color, secondary_color = colors

      @docx.h3 "Cost Summary", align: :center, padding: 10
      @docx.table(table_data, border_size: 1, border_color: '1f2f3f', width: 8000) do
        cell_style cells, size: 16, border_size: 0
        cell_style rows[-1], bold: true, background: secondary_color, color: '1f2f3f', size: 18, align: :center
        cell_style cols[1], align: :right
        cell_style rows[0], bold: true, background: primary_color, color: '1f2f3f', align: :center
      end
      @docx.p
    end

    private

    def table_data
      [['Cost Element', 'Calculated Cost']] +
        @grouped_items.map do |model, quote_items|
          [model.name, number_to_currency(quote_items.sum(&:final_price))]
        end +
        [['Total', number_to_currency(@quote.total_price)]]
    end

    def colors
      [@colors[:primary], @colors[:secondary]]
    end
  end
end
