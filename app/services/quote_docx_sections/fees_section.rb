module QuoteDocxSections
  class FeesSection
    include ActionView::Helpers::NumberHelper

    def initialize(docx, grouped_items)
      @docx = docx
      @grouped_items = grouped_items
    end

    # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    def build
      @docx.page
      @docx.h2 '1. Fees'
      @docx.table quote_items_data, border_size: 1, border_color: 'dadada', width: 10_000 do
        cell_style cells, size: 16, border_size: 0
      end
      @docx.table total_cost_data, border_size: 1, border_color: 'dadada', width: 10_000 do
        cell_style cells, size: 18, border_size: 0
        cell_style cells[0], background: '199dc7', color: 'ffffff', bold: true
        cell_style cells[1], background: '0248a1', color: 'ffffff', bold: true, width: 1300, align: :center
        cell_style cells[2], background: 'ffffff', color: '000000', width: 2500
      end
    end
    # rubocop:enable Metrics/AbcSize,Metrics/MethodLength

    private

    def quote_items_data
      @grouped_items.flat_map do |model, quote_items|
        main_header_row(model) + header_row + quote_item_rows(quote_items)
      end
    end

    def total_cost_data
      price = @grouped_items.values.sum { |quote_items| quote_items.sum(&:final_price) }

      [['TOTAL COST', 'Total Cost', "#{format_number(price)} (USD)"]]
    end

    def main_header_row(model)
      [[
        {
          content: model.name,
          align: :left,
          background: '0248a1',
          color: 'ffffff',
          bold: true,
          colspan: 5
        }
      ]]
    end

    def header_row
      [[
        header_cell_style('Cost Component'),
        header_cell_style('Unit'),
        header_cell_style('Quantity'),
        header_cell_style('Total Cost'),
        header_cell_style('Notes')
      ]]
    end

    def header_cell_style(name)
      {
        content: name,
        align: :left,
        background: '199dc7',
        color: 'ffffff'
      }
    end

    def quote_item_rows(quote_items)
      quote_items.map do |qi|
        [
          qi.item.name,
          quantity_or_unit_cell(qi.pricing_parameters.keys),
          quantity_or_unit_cell(qi.pricing_parameters.values),
          format_number(qi.final_price, 'Included'),
          qi.note&.is_printable ? qi.note.notes.to_s : "-"
        ]
      end
    end

    def quantity_or_unit_cell(array)
      Caracal::Core::Models::TableCellModel.new do |cell|
        if array.empty?
          cell.p '-'
        else
          array.each do |value|
            cell.p value
          end
        end
      end
    end

    def format_number(number, default = '-', currency: true)
      return default if number.nil? || number.zero?

      (currency ? number_to_currency(number) : number)
    end
  end
end
