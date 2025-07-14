class QuoteSerializer
  include JSONAPI::Serializer

  attributes :user_id, :customer_id, :total_price, :step, :contract_type_id, :contract_start_date, :contract_end_date
end
