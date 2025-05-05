export const normalizeApiCategories = (data) => {
  return data.map((item) => {
    return {
      id: Number(item.id), // Convert id to a number because JSON:API (via jsonapi-serializer) returns it as a string
      name: item.attributes.name,
      description: item.attributes.description,
    }
  })
}

export const normalizeApiItems = (data) => {
  return data.map((item) => {
    return {
      id: Number(item.id),
      name: item.attributes.name,
      description: item.attributes.description,
      category_id: Number(item.attributes.category_id),
      fixed_parameters: item.attributes.fixed_parameters,
      pricing_options: item.attributes.pricing_options,
      is_disabled: item.attributes.is_disabled,
      is_fixed: item.attributes.is_fixed,
      is_open: item.attributes.is_open,
      is_selectable_options: item.attributes.is_selectable_options,
      open_parameters_label: item.attributes.open_parameters_label,
      formula_parameters: item.attributes.formula_parameters,
      calculation_formula: item.attributes.calculation_formula,
    }
  })
}
