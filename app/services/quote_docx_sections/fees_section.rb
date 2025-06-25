module QuoteDocxSections
  class FeesSection
    include ActionView::Helpers::NumberHelper

    def initialize(docx, grouped_items)
      @docx = docx
      @grouped_items = grouped_items
    end

    def build
      8.times { @docx.p }
      @docx.h2 '1. Fees'
      @docx.table table_data, border_size: 1, border_color: 'dadada' do
        cell_style cells, size: 16, border_size: 0
        cell_style cells[-3], background: '199dc7', colspan: 3, size: 18, color: 'ffffff', bold: true
        cell_style cells[-2], background: '0248a1', size: 18, color: 'ffffff', bold: true
        cell_style cells[-1], background: 'ffffff', color: '000000', size: 18
      end
    end

    private

    def table_data
      @grouped_items.flat_map do |model, quote_items|
        main_header_row(model) + column_header_row + quote_item_rows(quote_items)
      end + total_cost_row
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

    def column_header_row
      [[
        header_cell_style('Cost Component', grow: true),
        header_cell_style('Unit'),
        header_cell_style('Quantity'),
        header_cell_style('Total Cost'),
        header_cell_style('Notes', grow: true)
      ]]
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

    def header_cell_style(name, grow: false)
      {
        content: name,
        align: :left,
        background: '199dc7',
        color: 'ffffff'
      }.merge(grow ? { width: 2000 } : {})
    end

    def total_cost_row
      price = @grouped_items.values.sum { |quote_items| quote_items.sum(&:final_price) }

      [['TOTAL COST', 'Total Cost', "#{format_number(price)} (USD)"]]
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
