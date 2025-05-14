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
    file = Tempfile.new(["quote_#{@quote.id}", '.docx'])
    file.binmode
    Caracal::Document.save file.path, &block
    file.rewind
    file
  rescue StandardError => e
    file&.close
    file&.unlink
    raise e
  end
end
