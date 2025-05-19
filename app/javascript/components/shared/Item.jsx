import React, { useState } from 'react'
import { PcItemFormGroup, PcItemInputControl, PcItemSelectControl } from '../ui'
import { getItemTypeConditions } from '../utils'
import { fetchQuoteItems } from '../services'

export const Item = ({ itemData, selectedOptions, setSelectedOptions, quoteId }) => {
  const quoteItem = itemData.attributes
  const {
    isItemFixed,
    isItemOpen,
    isItemSelectableOptions,
    isShowSimpleParams,
    isShowCombinedParams,
  } = getItemTypeConditions(quoteItem.item)

  const { is_open, is_selectable_options, open_parameters_label, pricing_options, fixed_parameters } = quoteItem.item

  const [selectedValues, setSelectedValues] = useState(
    is_selectable_options
      ? Object.fromEntries(Object.keys(pricing_options).map((key) => [key, quoteItem.pricing_parameters[key] || 0]))
      : {},
  )
  const [openValues, setOpenValues] = useState(
    is_open
      ? Object.fromEntries(open_parameters_label.map((label) => [label, quoteItem.pricing_parameters[label] || 0]))
      : {},
  )
  const [discountValue, setDiscountValue] = useState(Number(quoteItem.discount) || 0)

  function isValidDiscount(value) {
    let num = parseFloat(value)

    num = isNaN(num) ? 0 : num

    const rounded = Math.round(num * 100) / 100

    return rounded >= 0.0 && rounded <= 100.0
  }

  const updateQuoteItem = (newSelectedValues, newOpenValues, newDiscount) => {
    const quoteItemParameters = {}

    if (is_open) {
      quoteItemParameters.open_param_values = newOpenValues
    }

    if (is_selectable_options) {
      quoteItemParameters.select_param_values = newSelectedValues
    }

    fetchQuoteItems.update(quoteId, itemData.id, {
      quote_item: {
        ...quoteItemParameters,
        discount: newDiscount || 0,
      },
    }).then((updatedQuoteItem) => {
      setSelectedOptions(selectedOptions.map((option) => ({
        ...option,
        quote_items: option.quote_items.map((item) =>
          updatedQuoteItem.data.id === item.id ? updatedQuoteItem.data : item,
        ),
      })))
    })
  }

  const handleSelectedChange = (label) => (value) => {
    const updatedValues = { ...selectedValues, [label]: value === '' ? 0 : value }

    setSelectedValues(updatedValues)
    updateQuoteItem(updatedValues, openValues, discountValue)
  }

  const handleOpenChange = (label) => (e) => {
    const { value } = e.target
    const updated = { ...openValues, [label]: Number(value) }

    setOpenValues(updated)
    updateQuoteItem(selectedValues, updated, discountValue)
  }

  const handleDiscountChange = (e) => {
    const { value } = e.target

    let numericValue = parseFloat(value)

    if (isNaN(numericValue)) numericValue = 0
    numericValue = Math.max(0, Math.min(100, numericValue))

    setDiscountValue(numericValue)

    updateQuoteItem(selectedValues, openValues, numericValue)
  }

  const renderFixedParams = () =>
    Object.entries(fixed_parameters || {}).map(([label, value]) => (
      <PcItemFormGroup key={label} label={label}>
        <PcItemInputControl paramType="price" value={parseFloat(value)} />
      </PcItemFormGroup>
    ))

  const renderOpenParams = () =>
    (open_parameters_label || []).map((label) => (
      <PcItemFormGroup key={label} paramType="open-param" label={label}>
        <PcItemInputControl
          paramType="open-price-input"
          value={openValues[label] || 0}
          onChange={handleOpenChange(label)}
        />
      </PcItemFormGroup>
    ))

  const renderSelectParams = () =>
    Object.entries(pricing_options || {}).map(([paramKey, { options }]) => (
      <PcItemFormGroup key={`select-${paramKey}`} paramType="selectable-param" label={paramKey}>
        <PcItemSelectControl
          value={selectedValues[paramKey]}
          options={Object.entries(options).map(([label, value]) => ({ label, value }))}
          onChange={handleSelectedChange(paramKey)}
        />
      </PcItemFormGroup>
    ))

  const renderDiscountInput = () => (
    <PcItemFormGroup paramType="discount" label="Discount">
      <PcItemInputControl paramType="discount"
                          value={discountValue}
                          onChange={handleDiscountChange} />
    </PcItemFormGroup>
  )

  return (
    <div>
      {isShowSimpleParams && (
        <div className={'d-flex flex-column gap-3 px-0 align-items-end'}>
          <div className="d-flex flex-wrap align-items-end gap-3">
            {isItemFixed && renderFixedParams()}
            <PcItemFormGroup paramType="discounted-price" label="Discounted price">
              <PcItemInputControl
                paramType="discounted-price"
                value={Number(quoteItem.final_price) > 0 ? Number(quoteItem.final_price).toFixed(2) : 0}
              />
            </PcItemFormGroup>
          </div>

          <div className="d-flex flex-wrap align-items-end gap-3">
            {isItemOpen && renderOpenParams()}
            {isItemSelectableOptions && renderSelectParams()}
            {renderDiscountInput()}
          </div>
        </div>
      )}

      {isShowCombinedParams && (
        <div className="d-flex flex-column flex-md-row gap-5 pt-2 align-items-start justify-content-between">
          {/* Left Side */}
          <div className={'d-flex flex-column gap-3 px-0 pc-item-price-param align-items-start'}>
            <div className="d-flex flex-wrap gap-3">
              {/* Select Values */}
              {Object.entries(pricing_options || {}).map(([paramKey, { value_label }]) => (
                <PcItemFormGroup key={`label-${paramKey}`} label={value_label}>
                  <PcItemInputControl
                    paramType="select-price-value"
                    value={quoteItem.pricing_parameters[paramKey] || ''}
                    disabled
                  />
                </PcItemFormGroup>
              ))}
              {renderFixedParams()}
            </div>

            <div className="d-flex flex-wrap gap-3">
              {renderSelectParams()}
              {renderOpenParams()}
            </div>
          </div>

          {/* Right Side */}
          <div className={'d-flex flex-column gap-3 px-0 align-items-end pc-item-price-param'}>
            <div className="d-flex flex-wrap justify-content-end gap-3">
              <PcItemFormGroup paramType="price" label="Price">
                <PcItemInputControl
                  paramType="price"
                  value={Number(quoteItem.price) > 0 ? Number(quoteItem.price).toFixed(2) : 0}
                />
              </PcItemFormGroup>

              <PcItemFormGroup paramType="discounted-price" label="Discounted price">
                <PcItemInputControl
                  paramType="discounted-price"
                  value={Number(quoteItem.final_price) > 0 ? Number(quoteItem.final_price).toFixed(2) : 0}
                />
              </PcItemFormGroup>
            </div>

            <div className="d-flex flex-wrap justify-content-end gap-3">{renderDiscountInput()}</div>
          </div>
        </div>
      )}
    </div>
  )
}
