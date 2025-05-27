import React from 'react'
import { getExpandCollapseStates } from '../utils'
import { ExpandCollapseButtons } from './ExpandCollapseButtons'
import { MultiSelectDropdown } from './MultiSelectDropdown'
import { fetchQuoteItems } from '../services'
import { TotalPrice } from '../ui'

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
                                     setExpandedAccordions,
                                   }) => {
  const {
    shouldDisableExpandBtn,
    shouldDisableCollapseBtn,
  } = getExpandCollapseStates(selectedOptions, expandedAccordions)

  const isSelected = (option) => selectedOptions.some((item) => item.id === option.id && item.type === option.type)

  const replaceItem = (realItem, foundSelectedOption, tempId) => {
    setSelectedOptions((prev) =>
      prev.map((opt) =>
        opt.tempId === tempId
          ? { ...foundSelectedOption, quote_items: Array.isArray(realItem) ? realItem : [realItem] }
          : opt,
      ),
    )
  }

  const createByOptionType = (foundSelectedOption) => {
    const tempId = `temp-${Date.now()}`
    const optimisticItem = { ...foundSelectedOption, quote_items: [], tempId }

    setSelectedOptions((prev) => [...prev, optimisticItem])
    setExpandedAccordions((prev) => [...prev, foundSelectedOption.id])

    switch (foundSelectedOption.type) {
      case 'category':
        fetchQuoteItems.createFromCategory(quoteId, foundSelectedOption.id)
          .then((quoteItems) => replaceItem(quoteItems.data, foundSelectedOption, tempId))
        break
      case 'item':
        fetchQuoteItems.createFromItem(quoteId, foundSelectedOption.id)
          .then((quoteItem) => replaceItem(quoteItem.data, foundSelectedOption, tempId))
        break
      default:
        console.error('Invalid option type', foundSelectedOption)
        break
    }
  }

  function findRemovedItem(original, updated) {
    const updatedKeys = new Set(updated.map(i => `${i.type}:${i.id}`))
    return original.find(i => !updatedKeys.has(`${i.type}:${i.id}`))
  }

  const hasQuoteItems = (option) => option.quote_items !== undefined

  const handleOptionChange = (newSelectedOptions) => {
    if (newSelectedOptions.every((option) => hasQuoteItems(option))) {
      const item = findRemovedItem(selectedOptions, newSelectedOptions)
      if (item) showDeleteModal(item)
      return
    }

    if (newSelectedOptions.length === 1 && hasQuoteItems(newSelectedOptions[0])) {
      showDeleteModal(newSelectedOptions[0])
      return
    }

    const foundSelectedOption = newSelectedOptions.find((option) => !hasQuoteItems(option))
    const removedSelectedOption = selectedOptions.find((option) => foundSelectedOption.id === option.id && foundSelectedOption.type === option.type)

    if (removedSelectedOption) {
      showDeleteModal(removedSelectedOption)
    } else {
      createByOptionType(foundSelectedOption)
    }
  }

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
        <TotalPrice totalPrice={totalPrice} />
      </div>
    </div>
  )
}
