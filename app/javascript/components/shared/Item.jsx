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

  const [selectedValue, setSelectedValue] = useState(quoteItem.is_selectable_options ? quoteItem.pricing_parameters[Object.keys(quoteItem.pricing_options)[0]] : 0)
  const [openValue, setOpenValue] = useState(quoteItem.is_open ? quoteItem.pricing_parameters[quoteItem.item.open_parameters_label[0]] : 0)
  const [discountValue, setDiscountValue] = useState(quoteItem.discount || 0)

  const handleSelectedChange = (label) => (value) => {
    console.info('handleSelectedChange', label, value)

    setSelectedValue(value)
    updateQuoteItem({
      select_param_values: { [label]: value },
    })
  }

  const handleOpenChange = (label) => (e) => {
    console.info('handleOpenChange', e, label)

    const value = e.target.value || 0
    setOpenValue(value)
    updateQuoteItem({
      open_param_values: { [label]: value },
    })
  }

  const handleDiscountChange = (e) => {
    console.info('handleDiscountChange', e)

    const value = e.target.value || 0
    setDiscountValue(value)
    updateQuoteItem({
      discount: value,
    })
  }

  const updateQuoteItem = (params) => {
    fetchQuoteItems.update(quoteId, itemData.id, {
      quote_item: {
        ...params,
      },
    }).then((updatedQuoteItem) => {
      setSelectedOptions(selectedOptions.map((option) => {
        option.quote_items = option.quote_items.map((item) => {
          if (updatedQuoteItem.data.id === item.id) {
            return updatedQuoteItem.data
          }
          return item
        })
        return option
      }))
    })
  }

  const renderFixedParams = () =>
    Object.entries(quoteItem.item.fixed_parameters || {}).map(([label, value]) => (
      <PcItemFormGroup key={label} label={label}>
        <PcItemInputControl paramType="price" value={parseFloat(value)} />
      </PcItemFormGroup>
    ))

  const renderOpenParams = () =>
    (quoteItem.item.open_parameters_label || []).map((label) => (
      <PcItemFormGroup key={label} paramType="open-param" label={label}>
        <PcItemInputControl
          paramType="open-price-input"
          value={openValue}
          onChange={handleOpenChange(label)}
        />
      </PcItemFormGroup>
    ))

  const renderSelectParams = () =>
    Object.entries(quoteItem.item.pricing_options || {}).map(([paramKey, { options }]) => (
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
                          max={100}
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
              {Object.entries(quoteItem.item.pricing_options || {}).map(([paramKey, { value_label }]) => (
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
