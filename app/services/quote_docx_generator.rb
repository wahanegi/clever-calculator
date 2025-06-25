class QuoteDocxGenerator
  def initialize(quote)
    @setting = Setting.current
    @logo = @setting.word_header_document_logo
    @quote = quote
    @grouped_items = grouped_quote_items
    @colors = parsed_brand_colors
    @logo_size = logo_dimensions
  end

  def call
    build_docx do |docx, logo|
      QuoteDocxSections::HeaderSection.new(docx, logo&.path, @colors, @logo_size).build
      QuoteDocxSections::ClientInfoSection.new(docx, @quote.customer, @grouped_items.keys.map(&:name)).build
      QuoteDocxSections::FeesSection.new(docx, @grouped_items).build
      QuoteDocxSections::AdditionalWarrantiesSection.new(docx).build
      QuoteDocxSections::AuthorizedPartiesSection.new(docx, @quote.customer).build
    end
  end

  private

  def grouped_quote_items
    @quote.quote_items.each_with_object({}) do |quote_item, grouped_data|
      item = quote_item.item
      key = item.category || item

      grouped_data[key] ||= []
      grouped_data[key] << quote_item
    end
  end

  def build_docx
    logo_file = logo_tempfile
    docx_file = docx_tempfile

    docx_file.binmode
    Caracal::Document.save(docx_file.path) do |document|
      yield document, logo_file
    end
    docx_file.rewind
    docx_file.read
  ensure
    close_and_remove_each logo_file, docx_file
  end

  def logo_tempfile
    io, extension = fetch_logo

    return if io.nil? || extension.nil?

    file = Tempfile.new ['logo', extension]
    file.binmode
    file.write(io.read)
    file.rewind
    file
  end

  def docx_tempfile
    Tempfile.new(["quote_#{@quote.id}", ".docx"])
  end

  def close_and_remove_each(*files)
    files.each do |f|
      f&.close
      f&.unlink
    end
  end

  def fetch_logo
    return unless @logo.attached?

    blob = @logo.blob
    [StringIO.new(blob.download), ".#{blob.filename.extension}"]
  end

  def parsed_brand_colors
    brand_style = BrandColorParser.new(@setting.style)

    { primary: brand_style.primary_color.remove('#'),
      secondary: brand_style.secondary_color.remove('#'),
      blue_light: brand_style.blue_light_color.remove('#') }
  end

  def logo_dimensions
    return unless @logo.attached?

    @logo.analyze unless @logo.analyzed?

    width = @logo.metadata[:width]
    height = @logo.metadata[:height]

    Rails.logger.warn "Logo metadata is missing dimensions: #{@logo.metadata.inspect}" if width.nil? || height.nil?

    { width: width || 120, height: height || 120 }
  end
end
