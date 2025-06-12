module QuoteDocxSections
  class HeaderSection
    MAX_LOGO_WIDTH = 300
    MAX_LOGO_HEIGHT = 150

    def initialize(docx, logo_path, colors, logo_size)
      @docx = docx
      @logo_path = logo_path
      @colors = colors
      @logo_size = resize_to_max(logo_size)
    end

    def call
      @docx.page_margins top: 580, bottom: 1400, left: 580, right: 580
      @docx.page_numbers true, align: :right, label: 'Page'
      @docx.img @logo_path, width: @logo_size[:width], height: @logo_size[:height], align: :center if @logo_path
      @docx.p '230 W Ohio St, Suite 520, Chicago IL 60564', size: 13, align: :center
      @docx.hr size: 4, color: @colors[:primary], spacing: 8
    end

    private

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
