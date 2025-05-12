export const getExpandCollapseStates = (selectedCategories, expandedAccordions) => {
  const selectedCategoriesCount = selectedCategories.length

  let shouldDisableExpandBtn = true
  let shouldDisableCollapseBtn = true

  // Both buttons stay disabled if no categories are selected
  if (selectedCategoriesCount === 0) {
    return { shouldDisableExpandBtn, shouldDisableCollapseBtn }
  }

  // Count how many of the selected categories are currently expanded
  const expandedAccordionsCount = selectedCategories.filter(category =>
    expandedAccordions.includes(category.id),
  ).length

  // True if all selected categories are expanded
  const allExpanded = expandedAccordionsCount === selectedCategoriesCount
  // True if none of the selected categories are expanded
  const allCollapsed = expandedAccordionsCount === 0

  // If exactly one category is selected
  if (selectedCategoriesCount === 1) {
    // Get "true" if one category is already expanded
    shouldDisableExpandBtn = expandedAccordionsCount !== 0
    // Get "true" if one category is not expanded
    shouldDisableCollapseBtn = expandedAccordionsCount !== 1
  } else {
    // Get "true" if all selected categories are already expanded
    shouldDisableExpandBtn = allExpanded
    // Get "true" if all selected categories are already collapsed
    shouldDisableCollapseBtn = allCollapsed
  }

  return {
    shouldDisableExpandBtn,
    shouldDisableCollapseBtn,
  }
}
