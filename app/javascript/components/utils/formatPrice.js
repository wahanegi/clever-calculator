export const formatPrice = (value, decimals = 2) => {
  return Number.parseFloat(value).toFixed(decimals)
}
