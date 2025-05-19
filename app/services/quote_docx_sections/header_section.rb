module QuoteDocxSections
  class HeaderSection
    MAX_LOGO_SIZE = { width: 300, height: 150 }.freeze

    def initialize(docx, image_path, colors, logo_size)
      @docx = docx
      @image_path = image_path
      @colors = colors
      @logo_size = resize_to_max logo_size[:width], logo_size[:height], MAX_LOGO_SIZE[:width], MAX_LOGO_SIZE[:height]
    end

    def call
      @docx.page_margins top: 580, bottom: 1400, left: 580, right: 580
      @docx.page_numbers true, align: :right, label: 'Page'
      @docx.img @image_path, width: @logo_size[:width], height: @logo_size[:height], align: :center
      @docx.p '230 W Ohio St, Suite 520, Chicago IL 60564', size: 13, align: :center
      @docx.hr size: 4, color: @colors[:primary], spacing: 8
    end

    private

    def resize_to_max(original_width, original_height, max_width, max_height)
      width_ratio = max_width.to_f / original_width
      height_ratio = max_height.to_f / original_height
      scale = [width_ratio, height_ratio].min

      new_width = (original_width * scale).round
      new_height = (original_height * scale).round

      { width: new_width, height: new_height }
    end
  end
end
