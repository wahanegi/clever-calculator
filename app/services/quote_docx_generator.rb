class QuoteDocxGenerator
  def initialize(quote)
    @quote = quote
  end

  def call
    build_docx do |docx|
      docx.h1 "Quote ##{@quote.id}", align: :center
      # Add more content as needed
    end
  end

  private

  def build_docx(&block)
    tempfile = Tempfile.new(["quote_#{@quote.id}", '.docx'])
    tempfile.binmode
    Caracal::Document.save tempfile.path, &block
    tempfile.rewind
    tempfile
  rescue StandardError => e
    tempfile&.close
    tempfile&.unlink
    raise e
  end
end
