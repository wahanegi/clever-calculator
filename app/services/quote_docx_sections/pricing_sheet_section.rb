module QuoteDocxSections
  class PricingSheetSection
    def initialize(docx, colors, quote)
      @docx = docx
      @colors = colors
      @quote = quote
    end

    def call
      primary_color = @colors[:primary]

      @docx.h3 "PRICING SHEET", align: :center, padding: 20
      @docx.table(table_data) do
        cell_style cells, size: 16, border_size: 0, padding: 50, line: 100
        cell_style cols[0], bold: true, width: 2300, color: primary_color
        cell_style cols[1], width: 3800
        cell_style cols[2], bold: true, width: 1800, color: primary_color
      end
      @docx.p
    end

    private

    def table_data
      [
        generated_and_name_row,
        company_and_name_row,
        email_row,
        phone_and_title_row
      ]
    end

    def generated_and_name_row
      ['Generated on:', Time.current.strftime('%B %d, %Y'),
       'Company Name:', @quote.customer&.company_name || '-']
    end

    def company_and_name_row
      ['Company Representative:', @quote.user&.name || '-',
       'Client Name:', @quote.customer&.full_name || '-']
    end

    def email_row
      ['Representative Email:', @quote.user&.email || '-',
       'Email:', @quote.customer&.email || '-']
    end

    def phone_and_title_row
      ['Representative Phone:', '-',
       'Customer Title:', @quote.customer&.position || '-']
    end
  end
end
