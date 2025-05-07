export const getItemTypeConditions = (itemData = {}) => {
  const { is_fixed, is_open, is_selectable_options, fixed_parameters = {}, pricing_options = {} } = itemData

  const fixedParamCount = Object.keys(fixed_parameters).length
  const openParamCount = itemData.open_parameters_label?.length || 0
  const selectableParamCount = Object.keys(pricing_options).length

  const isItemFixed = Boolean(is_fixed && !is_open && !is_selectable_options && fixedParamCount === 1)
  const isItemOpen = Boolean(!is_fixed && is_open && !is_selectable_options && openParamCount === 1)
  const isItemSelectableOptions = Boolean(!is_fixed && !is_open && is_selectable_options && selectableParamCount === 1)

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
