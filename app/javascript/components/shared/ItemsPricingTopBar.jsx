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

  const handleQuoteItemSelect = async (option) => {
    console.info('handleQuoteItemSelect', option)

    if (isSelected(option)) {
      showDeleteModal(option)
    } else {
      switch (option.type) {
        case 'category':
          fetchQuoteItems.createFromCategory(quoteId, option.id)
            .then((quoteItems) => {
              setSelectedOptions(prevState => [...prevState, { ...option, quote_items: quoteItems.data }])
            })
          break
        case 'item':
          fetchQuoteItems.createFromItem(quoteId, option.id).then((quoteItem) => {
            setSelectedOptions(prevState => [...prevState, { ...option, quote_items: [quoteItem.data] }])
          })
          break
        default:
          console.error('Invalid option type', option)
          break
      }
    }
  }

  const handleOptionChange = (newSelected) => {
    console.info('handleOptionChange', newSelected)

    if (newSelected.length < selectedOptions.length) {
      const removedCategory = getRemovedCategory(selectedOptions, newSelected)

      if (removedCategory) {
        console.info('handleOptionChange', removedCategory)

        return showDeleteModal(removedCategory)
      }
    }
    setSelectedOptions(newSelected)
  }

  const TotalPrice = () =>
    <div className={'d-flex flex-column align-items-end'}>
      <div className={'d-flex gap-2 align-items-center'}>
        <hr className={'pc-hr-divider'} />
        <span className={'fs-10 text-secondary'}>Total price</span>
      </div>
      <span className={'fs-10 pc-fw-900'}>$&nbsp;{totalPrice}</span>
    </div>

  return (
    <div className="pc-grid-bar d-flex flex-column-reverse d-sm-grid align-items-center gap-8 mb-8">
      {/* Dropdown for selecting categories and items without category */}
      <MultiSelectDropdown
        isSelected={isSelected}
        selectedOptions={selectedOptions}
        selectableOptions={selectableOptions}
        onSelect={handleQuoteItemSelect}
        onChange={handleOptionChange}
      />

      <div className={'d-flex justify-content-between w-100'}>
        <ExpandCollapseButtons
          onExpand={expandAll}
          onCollapse={collapseAll}
          disableExpand={shouldDisableExpandBtn}
          disableCollapse={shouldDisableCollapseBtn}
        />
        <TotalPrice />
      </div>
    </div>
  )
}
