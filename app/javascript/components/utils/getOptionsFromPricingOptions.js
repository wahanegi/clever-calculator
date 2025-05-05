export const getOptionsFromPricingOptions = (pricingOptions = {}) => {
  const key = Object.keys(pricingOptions)[0]
  if (!key || typeof pricingOptions[key] !== 'object') return []

  const optionSet = pricingOptions[key].options
  if (!optionSet || typeof optionSet !== 'object') return []

  return Object.entries(optionSet).map(([range, price]) => ({
    value: price,
    name: range,
  }))
}
