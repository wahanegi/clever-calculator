module QuoteDocxSections
  class CostDetailsSection
    include ActionView::Helpers::NumberHelper

    def initialize(docx, colors, grouped_items)
      @docx = docx
      @colors = colors
      @grouped_items = grouped_items
    end

    def call
      primary_color = @colors[:primary]

      @docx.h3 'Cost Details', align: :center, padding: 10
      @docx.table(table_data, border_size: 1, border_color: '1f2f3f') do
        cell_style cells, size: 16, border_size: 0
        cell_style [cols[1], cols[2], cols[3]], align: :right
        cell_style rows[0], bold: true, background: primary_color, color: '1f2f3f', size: 16, align: :center
      end
    end

    private

    def table_data
      [['Item', 'Price', 'Discount', 'Final Price', 'Notes']] +
        @grouped_items.flat_map do |model, quote_items|
          [[header_row(model)]] + quote_items.map { |qi| row qi }
        end
    end

    def row(quote_item)
      [quote_item.item.name,
       quote_item.price.zero? ? '-' : number_to_currency(quote_item.price),
       quote_item.discount.zero? ? '-' : quote_item.discount,
       quote_item.final_price.zero? ? 'Included' : number_to_currency(quote_item.final_price),
       quote_item.note&.is_printable ? quote_item.note.notes.to_s : "-"]
    end

    def header_row(model)
      { content: model.name,
        colspan: 5,
        background: @colors[:blue_light],
        color: '1f2f3f', align: :center,
        bold: true,
        size: 18 }
    end
  end
end
