class CategorySerializer
  include JSONAPI::Serializer

  attributes :name, :description

  has_many :items
end
