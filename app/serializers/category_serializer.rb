class CategorySerializer
  include JSONAPI::Serializer

  attributes :name, :description
end
