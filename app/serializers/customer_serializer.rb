class CustomerSerializer
  include JSONAPI::Serializer

  attributes :company_name, :email, :position, :address, :notes, :first_name, :last_name, :full_name
  attribute :logo do |customer|
    customer.logo.url if customer.logo.attached?
  end
end
