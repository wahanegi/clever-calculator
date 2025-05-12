import React from 'react'
import { getExpandCollapseStates } from '../utils'
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

  const handleOptionChange = (newSelectedOptions) => {
    console.info('handleOptionChange', newSelectedOptions)

    if (newSelectedOptions.length === 1 && newSelectedOptions[0].quote_items !== undefined) {
      showDeleteModal(newSelectedOptions[0])
      return
    }

    const foundSelectedOption = newSelectedOptions.find((option) => option.quote_items === undefined)
    console.info('foundSelectedOption', foundSelectedOption)
    const removeSelectedOption = selectedOptions.find((option) => foundSelectedOption.id === option.id && foundSelectedOption.type === option.type)
    console.info('removeSelectedOption', removeSelectedOption)

    if (removeSelectedOption !== undefined) {
      showDeleteModal(removeSelectedOption)
    } else {
      switch (foundSelectedOption.type) {
        case 'category':
          fetchQuoteItems.createFromCategory(quoteId, foundSelectedOption.id).then((quoteItems) => {
            setSelectedOptions(prevState => [...prevState, { ...foundSelectedOption, quote_items: quoteItems.data }])
          })
          break
        case 'item':
          fetchQuoteItems.createFromItem(quoteId, foundSelectedOption.id).then((quoteItem) => {
            setSelectedOptions(prevState => [...prevState, { ...foundSelectedOption, quote_items: [quoteItem.data] }])
          })
          break
        default:
          console.error('Invalid option type', foundSelectedOption)
          break
      }
    }
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
