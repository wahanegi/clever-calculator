export const getOptionsFromPricingOptions = (pricingOptions = {}) => {
  const key = Object.keys(pricingOptions)[0]
  if (!key || typeof pricingOptions[key] !== 'object') {
    return { options: [], valueLabel: '' }
  }

  const { options: optionSet, value_label: valueLabel } = pricingOptions[key]
  if (!optionSet || typeof optionSet !== 'object') {
    return { options: [], valueLabel: valueLabel || '' }
  }

  const options = Object.entries(optionSet).map(([range, price]) => ({
    value: price,
    name: range,
  }))

  return { options, valueLabel }
}
