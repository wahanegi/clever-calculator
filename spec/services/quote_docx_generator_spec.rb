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
    it "generates a docx file and check if it contains 7 tables" do
      expect(document).not_to be_nil
      expect(document.tables.size).to eq 7
    end

    context 'when the document includes a client info section' do
      let(:client_table) { document.tables[1] }
      let(:cloverpop_table) { document.tables[2] }
      let(:summary_table) { document.tables[3] }

      it 'renders exactly 6 rows in the client table' do
        expect(client_table.rows.size).to eq 6
      end
      it 'renders exactly 2 rows in the cloverpop table' do
        expect(cloverpop_table.rows.size).to eq 2
      end
      it 'renders exactly 4 rows in the summary table' do
        expect(summary_table.rows.size).to eq 4
      end
    end

    context 'when the document includes a fees section' do
      let(:fees_table) { document.tables[4] }
      let(:total_cost_table) { document.tables[5] }
      let(:quote_item) { quote_items.first }

      it 'renders exactly 5 rows in the fees table' do
        expect(fees_table.rows.size).to eq 5

        category_cells = fees_table.rows[0].cells
        quote_item_cells = fees_table.rows[2].cells

        expect(category_cells[0].text).to eq(quote_item.item.category.name)
        expect(quote_item_cells[0].text).to eq(quote_item.item.name)
        expect(quote_item_cells[3].text).to eq(number_to_currency(quote_item.final_price))
      end

      it 'renders the total cost table' do
        expect(total_cost_table.rows[0].cells[2].text).to eq("#{number_to_currency(quote.total_price)} (USD)")
      end
    end

    context 'when the document includes a authorized parties section' do
      let(:authorized_parties_table) { document.tables[6] }

      it 'renders exactly 2 rows in the authorized parties table' do
        expect(authorized_parties_table.rows.size).to eq 2

        expect(authorized_parties_table.rows[0].cells[0].text).to eq "AGREED TO ON BEHALF OF #{quote.customer.company_name}"
        expect(authorized_parties_table.rows[0].cells[1].text).to eq "BY: ________________________________________#{quote.customer.full_name}#{quote.customer.position}#{quote.customer.company_name}"
      end
    end
  end
end
