export const getItemTypeConditions = (itemData = {}) => {
  const { is_fixed, is_open, is_selectable_options } = itemData

  const isItemFixed = Boolean(is_fixed && !is_open && !is_selectable_options)
  const isItemOpen = Boolean(!is_fixed && is_open && !is_selectable_options)
  const isItemSelectableOptions = Boolean(!is_fixed && !is_open && is_selectable_options)

  const isFixedOpen = Boolean(is_fixed && is_open && !is_selectable_options)
  const isSelectableOpen = Boolean(!is_fixed && is_open && is_selectable_options)
  const isSelectableFixed = Boolean(is_fixed && !is_open && is_selectable_options)

  const isShowSimpleParams = isItemFixed || isItemOpen || isItemSelectableOptions
  const isShowCombinedParams = isFixedOpen || isSelectableOpen || isSelectableFixed

  return {
    isItemFixed,
    isItemOpen,
    isItemSelectableOptions,
    isFixedOpen,
    isSelectableOpen,
    isSelectableFixed,
    isShowSimpleParams,
    isShowCombinedParams,
  }
}
