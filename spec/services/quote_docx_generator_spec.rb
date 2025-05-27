require "rails_helper"

RSpec.describe QuoteDocxGenerator do
  include ActionView::Helpers::NumberHelper

  let!(:quote) { create :quote }
  let!(:item) { create :item, :with_fixed_parameters }
  let!(:quote_items) { create_list :quote_item, 3, quote: quote, item: item, price: 0, discount: 0, final_price: 0 }
  let!(:quote_docx_generator) { QuoteDocxGenerator.new(quote) }
  # create a temp file
  let!(:docx_file) do
    Tempfile.open(['quote', '.docx']) do |file|
      file.write(quote_docx_generator.call.force_encoding('UTF-8'))
      file.rewind
      file
    end
  end
  let!(:document) { Docx::Document.open(docx_file.path) }

  # cleanup temp file
  after do
    docx_file.close
    docx_file.unlink
  end

  describe "#call" do
    it "generates a docx file and check if it contains 3 tables" do
      expect(document).not_to be_nil
      expect(document.tables.size).to eq 3 # pricing sheet + summary + cost details
    end

    context 'with the document includes a pricing sheet section' do
      let(:table_pricing_sheet) { document.tables[0] }

      it 'check if the table contains 4 rows' do
        expect(table_pricing_sheet.rows.size).to eq 4
      end
    end

    context 'with the document includes a a summary section' do
      let(:table_summary) { document.tables[1] }

      it 'checks if the table contains 3 rows' do
        expect(table_summary.rows.size).to eq 3 # header + 1 category + total price

        category = table_summary.rows[1].cells

        expect(category[0].text).to eq(quote_items.first.item.category.name)
        expect(category[1].text).to eq(number_to_currency(quote.total_price))
      end
    end

    context 'with the document includes a cost details section' do
      let(:table_cost_details) { document.tables[2] }

      it 'checks if the table contains 5 rows' do
        expect(table_cost_details.rows.size).to eq 5 # header + name item + 3 quote items

        table_cost_details.rows.drop(2).map { |row| row.cells[0].text }.each do |name|
          expect(name).to eq(item.name)
        end

        prices = table_cost_details.rows.drop(2).map { |row| row.cells[1].text }

        expect(prices).to eq(quote_items.map { |quote_item| number_to_currency(quote_item.final_price) })
      end
    end
  end
end
