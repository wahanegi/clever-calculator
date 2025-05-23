class GroupedQuoteItemsSerializer
  def initialize(quote_items)
    @quote_items = quote_items
  end

  def serializable_hash
    data = @quote_items.each_with_object({}) do |quote_item, grouped_data|
      item = quote_item.item
      key = item.category || item

      grouped_data[key] ||= []
      grouped_data[key] << quote_item
    end

    data.map do |model, quote_items|
      generate_data(model, quote_items)
    end
  end

  private

  def generate_data(model, quote_items)
    {
      id: model.id,
      name: model.name,
      quote_items: QuoteItemSerializer.new(quote_items, is_collection: true).serializable_hash[:data] || [],
      type: model.class.name.downcase
    }
  end
end
