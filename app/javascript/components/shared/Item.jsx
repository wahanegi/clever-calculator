import React, { useState } from 'react'
import { PcItemFormGroup, PcItemInputControl, PcItemSelectControl } from '../ui'
import { discountedPrice, getItemTypeConditions } from '../utils'

// TODO: will be replaced with value fetch from backend
const DUMMY_PRICE = 7777

export const Item = ({ itemData, className = '' }) => {
  const [openParamValues, setOpenParamValues] = useState({})
  const [selectableValues, setSelectableValues] = useState({})
  const [discount, setDiscount] = useState('')

  const { isItemFixed, isItemOpen, isItemSelectableOptions, isShowSimpleParams, isShowCombinedParams } =
    getItemTypeConditions(itemData)

  const handleSelectChange = (key) => (label) => {
    const value = itemData.pricing_options?.[key]?.options?.[label] ?? ''
    setSelectableValues((prev) => ({
      ...prev,
      [key]: { label, value },
    }))
  }

  const handleOpenParamChange = (label) => (e) => {
    setOpenParamValues((prev) => ({
      ...prev,
      [label]: e.target.value,
    }))
  }

  const renderFixedParams = () =>
    Object.entries(itemData.fixed_parameters || {}).map(([label, value]) => (
      <PcItemFormGroup key={label} label={label}>
        <PcItemInputControl paramType="price" value={parseFloat(value)} />
      </PcItemFormGroup>
    ))

  const renderOpenParams = () =>
    (itemData.open_parameters_label || []).map((label) => (
      <PcItemFormGroup key={label} paramType="open-param" label={label}>
        <PcItemInputControl
          paramType="open-price-input"
          value={openParamValues[label] || ''}
          onChange={handleOpenParamChange(label)}
        />
      </PcItemFormGroup>
    ))

  const renderSelectParams = () =>
    Object.entries(itemData.pricing_options || {}).map(([paramKey, { options }]) => (
      <PcItemFormGroup key={`select-${paramKey}`} paramType="selectable-param" label={paramKey}>
        <PcItemSelectControl
          value={selectableValues[paramKey]?.label || ''}
          options={Object.entries(options).map(([label]) => ({
            label,
            value: label,
          }))}
          onChange={handleSelectChange(paramKey)}
        />
      </PcItemFormGroup>
    ))

  const renderDiscountInput = () => (
    <PcItemFormGroup paramType="discount" label="Discount">
      <PcItemInputControl paramType="discount" value={discount} onChange={(e) => setDiscount(e.target.value)} />
    </PcItemFormGroup>
  )

  return (
    <div>
      {isShowSimpleParams && (
        <div className={`d-flex flex-column gap-3 px-0 align-items-end ${className}`}>
          <div className="d-flex flex-wrap align-items-end gap-3">
            {isItemFixed && renderFixedParams()}
            <PcItemFormGroup paramType="discounted-price" label="Discounted price">
              <PcItemInputControl paramType="discounted-price" value={discountedPrice(DUMMY_PRICE, discount)} />
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
          <div className={`d-flex flex-column gap-3 px-0 pc-item-price-param align-items-start ${className}`}>
            <div className="d-flex flex-wrap gap-3">
              {/* Select Values */}
              {Object.entries(itemData.pricing_options || {}).map(([paramKey, { value_label }]) => (
                <PcItemFormGroup key={`label-${paramKey}`} label={value_label}>
                  <PcItemInputControl
                    paramType="select-price-value"
                    value={selectableValues[paramKey]?.value || ''}
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
          <div className={`d-flex flex-column gap-3 px-0 align-items-end pc-item-price-param ${className}`}>
            <div className="d-flex flex-wrap justify-content-end gap-3">
              <PcItemFormGroup paramType="price" label="Price">
                <PcItemInputControl paramType="price" value={DUMMY_PRICE} />
              </PcItemFormGroup>

              <PcItemFormGroup paramType="discounted-price" label="Discounted price">
                <PcItemInputControl paramType="discounted-price" value={DUMMY_PRICE} />
              </PcItemFormGroup>
            </div>

            <div className="d-flex flex-wrap justify-content-end gap-3">{renderDiscountInput()}</div>
          </div>
        </div>
      )}
    </div>
  )
}
