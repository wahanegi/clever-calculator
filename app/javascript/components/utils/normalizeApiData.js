export const normalizeApiCategories = (data) => {
  return data.map((item) => {
    return {
      id: Number(item.id), // Convert id to a number because JSON:API (via jsonapi-serializer) returns it as a string
      name: item.attributes.name,
      description: item.attributes.description,
    }
  })
}
