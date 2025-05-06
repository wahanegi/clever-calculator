export const getItemTypeConditions = (itemData = {}) => {
  const { is_fixed, is_open, is_selectable_options } = itemData

  const isItemFixed = Boolean(is_fixed && !is_open && !is_selectable_options)
  const isItemOpen = Boolean(!is_fixed && is_open && !is_selectable_options)
  const isItemSelectableOptions = Boolean(!is_fixed && !is_open && is_selectable_options)

  const isShowSimpleParams = isItemFixed || isItemOpen || isItemSelectableOptions
  const isShowCombinedParams = !isShowSimpleParams

  return {
    isItemFixed,
    isItemOpen,
    isItemSelectableOptions,
    isShowSimpleParams,
    isShowCombinedParams,
  }
}
