export const discountedPrice = (price, discount) => {
  const discountValue = Number(discount)
  return discountValue > 0 ? (price - (price * discountValue) / 100).toFixed(2) : price.toFixed(2)
}
