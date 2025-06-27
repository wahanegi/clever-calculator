module QuoteDocxSections
  class ClientInfoSection
    def initialize(docx, customer, items)
      @docx = docx
      @customer = customer
      @items = items
    end

    # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    def build
      @docx.table client_data, border_size: 1, border_color: 'eeeeee' do
        cell_style cells, border_size: 0
        cell_style cols[0], background: '199dc7', color: 'ffffff', align: :right,size: 20, font: 'Montserrat Medium'
        cell_style cols[1], color: '595959', background: 'ffffff', align: :left, size: 22, font: 'Montserrat Regular'
        cell_style cells[11], bold: true, color: '000000', size: 22, font: 'Aptos'
      end
      @docx.p
      @docx.table cloverpop_data, border_size: 1, border_color: 'eeeeee' do
        cell_style cells, border_size: 0
        cell_style cols[0], background: '0759ae', color: 'ffffff', align: :right, size: 20, font: 'Montserrat Medium'
        cell_style cols[1], color: '595959', background: 'ffffff', align: :left, size: 22, font: 'Montserrat Regular'
      end
      @docx.p
      @docx.table summary_data, border_size: 1, border_color: 'eeeeee' do
        cell_style cells, border_size: 0
        cell_style cols[0], bold: true, background: '677888', color: 'ffffff', align: :right,
                            font: 'Montserrat SemiBold', size: 20
        cell_style cols[1], color: '595959', background: 'ffffff', align: :left, font: 'Montserrat Medium', size: 22
      end
    end
    # rubocop:enable Metrics/AbcSize,Metrics/MethodLength

    private

    def client_data
      [
        ['Title:', presence_or_default(nil)],
        ['Date:', Date.current.strftime('%m/%d/%Y')],
        ['Customer Organization Name:', presence_or_default(@customer.company_name)],
        ['Customer Authorized Party (Parties):', presence_or_default(@customer.full_name)],
        ['Client Address:', presence_or_default(@customer.address)],
        ['Client Email:', presence_or_default(@customer.email)]
      ]
    end

    def cloverpop_data
      [
        ['Cloverpop Delivery lead:', 'Lanny Roytburg'],
        ['Cloverpop Delivery lead Email:', 'Lanny@cloverpop.com']
      ]
    end

    def summary_data
      [
        ['Summary Description:', presence_or_default(nil)],
        ['Terms of subscription & service:', presence_or_default(nil)],
        ['Contract Type:', presence_or_default(nil)],
        ['Capabilities Included:', Caracal::Core::Models::TableCellModel.new do |cell|
          @items.each do |item|
            cell.p item
          end
        end]
      ]
    end

    def presence_or_default(value, default = '-')
      value.presence || default
    end
  end
end
