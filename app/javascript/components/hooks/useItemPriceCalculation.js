import { useEffect, useState } from 'react'

export const useItemPriceCalculation = ({ fixedValue, openParamValue, selectableValue, discount, itemData }) => {
  const [basePrice, setBasePrice] = useState(fixedValue)
  const [discounted, setDiscounted] = useState(fixedValue)

  useEffect(() => {
    const open = Number(openParamValue) || 0
    const selectable = Number(selectableValue) || 0
    const discountValue = Number(discount)

    let price = fixedValue

    const isFixedOpen = itemData.is_fixed && itemData.is_open && !itemData.is_selectable_options
    const isSelectableOpen = !itemData.is_fixed && itemData.is_open && itemData.is_selectable_options
    const isSelectableFixed = itemData.is_fixed && !itemData.is_open && itemData.is_selectable_options
    const isItemOpen = !itemData.is_fixed && itemData.is_open && !itemData.is_selectable_options
    const isItemSelectable = !itemData.is_fixed && !itemData.is_open && itemData.is_selectable_options

    if (isFixedOpen) {
      price = fixedValue + open
    } else if (isSelectableOpen) {
      price = selectable * open
    } else if (isSelectableFixed) {
      price = fixedValue + selectable
    } else if (isItemOpen) {
      price = open
    } else if (isItemSelectable) {
      price = selectable
    }

    setBasePrice(price)

    const discountedPrice = discountValue > 0 ? price - (price * discountValue) / 100 : price

    setDiscounted(discountedPrice)
  }, [fixedValue, openParamValue, selectableValue, discount, itemData])

  return { basePrice, discounted }
}
