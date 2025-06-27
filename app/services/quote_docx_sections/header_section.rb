module QuoteDocxSections
  class HeaderSection
    MAX_LOGO_WIDTH = 120
    MAX_LOGO_HEIGHT = 40

    def initialize(docx, logo_path, logo_size)
      @docx = docx
      @logo_path = logo_path
      @logo_size = resize_to_max(logo_size)
    end

    # rubocop:disable Metrics/MethodLength
    def build
      @docx.font do
        name 'Montserrat SemiBold'
        name 'Montserrat Medium'
        name 'Montserrat Regular'
      end
      @docx.page_margins top: 700, bottom: 1500, left: 1150, right: 1150
      @docx.page_numbers true, align: :right, label: 'Confidential & Proprietary | Page ', size: 18, color: '000000'
      @docx.table company_data do
        cell_style cols[0], width: 4000
      end
      @docx.hr size: 10, spacing: 10, color: '0759ae'
    end
    # rubocop:enable Metrics/MethodLength

    private

    # rubocop:disable Metrics/MethodLength
    def company_data
      [[
        Caracal::Core::Models::TableCellModel.new do |cell|
          if @logo_path
            cell.img @logo_path, width: @logo_size[:width], height: @logo_size[:height], align: :left
          else
            2.times { cell.p }
          end
          cell.p 'CLEARBOX DECISIONS INC', size: 13, color: '677888', font: 'Montserrat Regular'
          cell.p 'DBA. CLOVERPOP', align: :left, size: 13, color: '677888', font: 'Montserrat Regular'
          cell.p '230 W. HURON ST, SUITE 520', align: :left, size: 13, color: '677888', font: 'Montserrat Regular'
          cell.p 'CHICAGO IL, 60654', align: :left, size: 13, color: '677888', font: 'Montserrat Regular'
        end,
        Caracal::Core::Models::TableCellModel.new do |cell|
          3.times { cell.p }
          cell.h1 'Cloverpop Statement of Work', align: :right, color: '677888', font: 'Montserrat SemiBold', size: 36
        end
      ]]
    end
    # rubocop:enable Metrics/MethodLength

    def resize_to_max(logo_size)
      return unless logo_size

      original_width = logo_size[:width]
      original_height = logo_size[:height]

      width_ratio = MAX_LOGO_WIDTH.to_f / original_width
      height_ratio = MAX_LOGO_HEIGHT.to_f / original_height
      scale = [width_ratio, height_ratio].min

      new_width = (original_width * scale).round
      new_height = (original_height * scale).round

      { width: new_width, height: new_height }
    end
  end
end
