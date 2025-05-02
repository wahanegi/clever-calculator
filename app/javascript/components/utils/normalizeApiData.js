export const normalizeApiCategories = (data) => {
  return data.map(item => ({
    id: item.id,
    name: item.attributes.name,
    description: item.attributes.description,
  }))
}
