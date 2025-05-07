class QuoteItemSerializer
  include JSONAPI::Serializer

  attributes :price, :discount, :final_price, :pricing_parameters

  belongs_to :item
end
