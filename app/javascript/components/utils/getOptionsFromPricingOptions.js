export const getOptionsFromPricingOptions = (pricingOptions = {}) => {
  const key = Object.keys(pricingOptions)[0]
  if (!key || typeof pricingOptions[key] !== 'object') return []

  return Object.entries(pricingOptions[key]).map(([range, price]) => ({
    value: price,
    name: `${range} - $${price}`,
  }))
}
