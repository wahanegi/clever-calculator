class QuoteSerializer
  include JSONAPI::Serializer

  attributes :user_id, :customer_id, :total_price, :step
end
