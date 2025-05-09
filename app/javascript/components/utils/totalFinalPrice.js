export const totalFinalPrice = (items) =>
  items.reduce((total, item) => (total + parseFloat(item.attributes?.final_price || 0)), 0)
    .toFixed(2)
