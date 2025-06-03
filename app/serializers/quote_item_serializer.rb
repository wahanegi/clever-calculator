class QuoteItemSerializer
  include JSONAPI::Serializer

  attributes :price, :discount, :final_price, :pricing_parameters

  attribute :item do |quote_item|
    quote_item.item.as_json(except: [:calculation_formula, :updated_at, :created_at])
  end

  attribute :note do |quote_item|
    quote_item.note.as_json(except: [:updated_at, :created_at])
  end
end
