import React from 'react'
import { getExpandCollapseStates, getRemovedCategory } from '../utils'
import { ExpandCollapseButtons } from './ExpandCollapseButtons'
import { MultiSelectDropdown } from './MultiSelectDropdown'
import { fetchQuoteItems } from '../services'

export const ItemsPricingTopBar = ({
                                     totalPrice,
                                     expandAll,
                                     collapseAll,
                                     expandedAccordions,
                                     selectedOptions,
                                     setSelectedOptions,
                                     showDeleteModal,
                                     selectableOptions,
                                     quoteId,
                                   }) => {
  const {
    shouldDisableExpandBtn,
    shouldDisableCollapseBtn,
  } = getExpandCollapseStates(selectedOptions, expandedAccordions)
  const isSelected = (option) => selectedOptions.some((item) => item.id === option.id && item.type === option.type)
  const findSelectedOption = (option) => selectedOptions.find((item) => item.id === option.id && item.type === option.type)

  const handleQuoteItemSelect = async (option) => {
    console.info('handleQuoteItemSelect',option)

    if (isSelected(option)) {
      showDeleteModal(findSelectedOption(option))
    } else {
      switch (option.type) {
        case 'category':
          const quoteItems = await fetchQuoteItems.createFromCategory(quoteId, option.id)
          setSelectedOptions(prevState => [...prevState, { ...option, quote_items: quoteItems.data }])
          break
        case 'item':
          const quoteItem = await fetchQuoteItems.createFromItem(quoteId, option.id)
          setSelectedOptions(prevState => [...prevState, { ...option, quote_items: [quoteItem.data] }])
          break
        default:
          console.error('Invalid option type')
          break
      }
    }
  }

  const handleQuoteItemChange = (newSelected) => {
    console.info('handleQuoteItemChange', newSelected)
    if (newSelected.length < selectedOptions.length) {
      const removedCategory = getRemovedCategory(selectedOptions, newSelected)

      if (removedCategory) {
        console.info('handleQuoteItemChange', removedCategory)

        return showDeleteModal(removedCategory)
      }
    }
    setSelectedOptions(newSelected)
  }

  return (
    <div className="pc-grid-bar d-flex flex-column-reverse d-sm-grid align-items-center gap-8 mb-8">
      {/* Dropdown for selecting categories and items without category */}
      <MultiSelectDropdown
        isSelected={isSelected}
        selectedOptions={selectedOptions}
        selectableOptions={selectableOptions}
        onSelect={handleQuoteItemSelect}
        onChange={handleQuoteItemChange}
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
