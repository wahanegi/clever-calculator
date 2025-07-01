module QuoteDocxSections
  class AuthorizedPartiesSection
    def initialize(docx, customer)
      @docx = docx
      @customer = customer
    end

    def build
      @docx.h2 '3. Authorized Parties', font: 'Montserrat SemiBold'
      @docx.p
      @docx.hr size: 10, spacing: 10, color: '54504a'
      @docx.p
      @docx.table authorized_parties_data, border_size: 1, border_color: '54504a' do
        cell_style cells, border_size: 0
      end
    end

    private

    def authorized_parties_data
      [
        [cell_left(@customer.company_name),
         cell_right(@customer.full_name, @customer.position, @customer.company_name)],
        [cell_left('Clearbox Decisions Inc. (Dba. Cloverpop.)', spacing: 1),
         cell_right('Lanny Roytburg', 'Chief Commercial Officer', bold_position: false)]
      ]
    end

    def cell_left(company_name, spacing: 2)
      Caracal::Core::Models::TableCellModel.new do |cell|
        spacing.times { cell.p }
        cell.p 'AGREED TO ON BEHALF OF ', size: 22, color: '606060', font: 'Montserrat SemiBold', bold: true
        cell.p company_name, size: 22, color: '0248a1', font: 'Montserrat SemiBold', bold: true
        spacing.times { cell.p }
      end
    end

    def cell_right(full_name, position, company_name = nil, bold_position: true)
      Caracal::Core::Models::TableCellModel.new do |cell|
        cell.p 'BY: ', size: 22, color: '606060', font: 'Montserrat SemiBold', bold: true
        cell.p
        cell.p '_' * 40, size: 22, color: '606060', font: 'Montserrat SemiBold'
        cell.p full_name, size: 22, color: '606060', font: 'Montserrat SemiBold', bold: true
        cell.p position, size: 22, color: '606060', font: 'Montserrat SemiBold', bold: bold_position, italic: true
        cell.p company_name, size: 18, color: '606060', font: 'Montserrat SemiBold' if company_name
      end
    end
  end
end
