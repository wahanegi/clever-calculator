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
  const selectedLabel = is_selectable_options ? Object.keys(pricing_options)[0] : null
  const openLabel = is_open ? open_parameters_label[0] : null

  const [selectedValue, setSelectedValue] = useState(is_selectable_options ? quoteItem.pricing_parameters[selectedLabel] : 0)
  const [openValue, setOpenValue] = useState(is_open ? quoteItem.pricing_parameters[openLabel] : 0)
  const [discountValue, setDiscountValue] = useState(quoteItem.discount || 0)

  function isValidDiscount(value) {
    const num = parseFloat(value)

    if (isNaN(num)) return false

    const rounded = Math.round(num * 100) / 100

    return rounded >= 0.0 && rounded <= 100.0
  }

  const updateQuoteItem = (newSelected, newOpen, newDiscount) => {
    const quoteItemParameters = {}

    if (is_open) {
      quoteItemParameters.open_param_values = { [openLabel]: newOpen }
    }

    if (is_selectable_options) {
      quoteItemParameters.select_param_values = { [selectedLabel]: newSelected }
    }

    fetchQuoteItems.update(quoteId, itemData.id, {
      quote_item: {
        ...quoteItemParameters,
        discount: newDiscount,
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
    setSelectedValue(value)

    updateQuoteItem(value, openValue, discountValue)
  }

  const handleOpenChange = (label) => (e) => {
    const value = e.target.value || 0
    setOpenValue(value)
    updateQuoteItem(selectedValue, value, discountValue)
  }

  const handleDiscountChange = (e) => {
    const value = e.target.value

    if (isValidDiscount(value)) {
      setDiscountValue(value)
      updateQuoteItem(selectedValue, openValue, value)
    }
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
          value={openValue}
          onChange={handleOpenChange(label)}
        />
      </PcItemFormGroup>
    ))

  const renderSelectParams = () =>
    Object.entries(pricing_options || {}).map(([paramKey, { options }]) => (
      <PcItemFormGroup key={`select-${paramKey}`} paramType="selectable-param" label={paramKey}>
        <PcItemSelectControl
          value={selectedValue}
          options={Object.entries(options).map(([label, value]) => ({ label, value: value }))}
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
              <PcItemInputControl paramType="discounted-price" value={quoteItem.final_price} />
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
                <PcItemInputControl paramType="price" value={quoteItem.price} />
              </PcItemFormGroup>

              <PcItemFormGroup paramType="discounted-price" label="Discounted price">
                <PcItemInputControl paramType="discounted-price" value={quoteItem.final_price} />
              </PcItemFormGroup>
            </div>

            <div className="d-flex flex-wrap justify-content-end gap-3">{renderDiscountInput()}</div>
          </div>
        </div>
      )}
    </div>
  )
}
