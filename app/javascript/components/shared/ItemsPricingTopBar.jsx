import React from 'react'
import { getExpandCollapseStates } from '../utils'
import { ExpandCollapseButtons } from './ExpandCollapseButtons'
import { MultiSelectDropdown } from './MultiSelectDropdown'

export const ItemsPricingTopBar = ({
  totalPrice,
  expandAll,
  collapseAll,
  expandedAccordions,
  selectedCategories,
  setSelectedCategories,
  showDeleteModal
}) => {
  const {
    shouldDisableExpandBtn,
    shouldDisableCollapseBtn,
  } = getExpandCollapseStates(selectedCategories, expandedAccordions)

  return (
    <div className="pc-grid-bar d-flex flex-column-reverse d-sm-grid align-items-center gap-8 mb-8">
      {/* Dropdown for selecting categories */}
      <MultiSelectDropdown
        selected={selectedCategories}
        setSelected={setSelectedCategories}
        showDeleteModal={showDeleteModal}
      />

      <div className={'d-flex justify-content-between w-100'}>
        {/* Expand/Collapse buttons */}
        <ExpandCollapseButtons
          onExpand={expandAll}
          onCollapse={collapseAll}
          disableExpand={shouldDisableExpandBtn}
          disableCollapse={shouldDisableCollapseBtn}
        />

        {/* Total price */}
        <div className={'d-flex flex-column align-items-end'}>
          <div className={'d-flex gap-2 align-items-center'}>
            <hr className={'pc-hr-divider'} />
            <span className={'fs-10 text-secondary'}>Total price</span>
          </div>
          <span className={'fs-10 pc-fw-900'}>$&nbsp;{totalPrice}</span>
        </div>
      </div>
    </div>
  )
}
