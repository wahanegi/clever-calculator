import React, { useState } from 'react'
import { Col, Row } from 'react-bootstrap'
import { PcItemFormGroup, PcItemInputControl, PcItemSelectControl } from '../ui'
import { discountedPrice, getItemTypeConditions, getOptionsFromPricingOptions } from '../utils'

// TODO: will be replaced with value fetch from backend
const DUMMY_PRICE = 7777

export const Item = ({ itemData, className = '' }) => {
  const fixedValue = parseFloat(Object.values(itemData.fixed_parameters)[0])
  const fixedValueLabel = Object.keys(itemData.fixed_parameters)[0]
  const { options, valueLabel } = getOptionsFromPricingOptions(itemData.pricing_options)
  const selectableParamLabel = Object.keys(itemData.pricing_options || {})[0] || ''

  const [openParamValue, setOpenParamValue] = useState('')
  const [selectableValue, setSelectableValue] = useState('')
  const [discount, setDiscount] = useState('')

  const { isItemFixed, isItemOpen, isItemSelectableOptions, isShowSimpleParams, isShowCombinedParams } =
    getItemTypeConditions(itemData)

  return (
    <div>
      {isShowSimpleParams && (
        <div className={`d-flex flex-column gap-3 px-0 align-items-end ${className}`}>
          <div className="d-flex flex-wrap align-items-end gap-3">
            {isItemFixed && (
              <PcItemFormGroup paramType="price" label="Price">
                <PcItemInputControl paramType="price" value={fixedValue} />
              </PcItemFormGroup>
            )}
            <PcItemFormGroup paramType="discounted-price" label="Discounted price">
              <PcItemInputControl paramType="discounted-price" value={discountedPrice(DUMMY_PRICE, discount)} />
            </PcItemFormGroup>
          </div>

          <div className="d-flex flex-wrap align-items-end gap-3">
            {isItemOpen && (
              <PcItemFormGroup paramType="open-price-input" label={itemData.open_parameters_label[0]}>
                <PcItemInputControl
                  paramType="open-price-input"
                  value={openParamValue}
                  onChange={(e) => setOpenParamValue(e.target.value)}
                />
              </PcItemFormGroup>
            )}
            {isItemSelectableOptions && (
              <PcItemFormGroup paramType="selectable-param" label={selectableParamLabel}>
                <PcItemSelectControl
                  value={selectableValue}
                  options={options}
                  onChange={(val) => setSelectableValue(val)}
                />
              </PcItemFormGroup>
            )}
            <PcItemFormGroup paramType="discount" label="Discount">
              <PcItemInputControl paramType="discount" value={discount} onChange={(e) => setDiscount(e.target.value)} />
            </PcItemFormGroup>
          </div>
        </div>
      )}

      {isShowCombinedParams && (
        <div className="d-flex flex-column flex-md-row gap-5 pt-2 align-items-start justify-content-between">
          {/* Left Side */}
          <div className={`d-flex flex-column gap-3 px-0 pc-item-price-param ${className}`}>
            <div className="d-flex flex-wrap gap-3">
              {itemData.is_selectable_options && (
                <PcItemFormGroup label={valueLabel}>
                  <PcItemInputControl
                    paramType="select-price-value"
                    value={selectableValue}
                    onChange={(e) => setOpenParamValue(e.target.value)}
                    disabled
                  />
                </PcItemFormGroup>
              )}
              {itemData.is_fixed && (
                <PcItemFormGroup label={fixedValueLabel}>
                  <PcItemInputControl paramType="price" value={fixedValue} disabled />
                </PcItemFormGroup>
              )}
            </div>

            <div className="d-flex flex-wrap gap-3">
              {itemData.is_selectable_options && (
                <PcItemFormGroup paramType="selectable-param" label={selectableParamLabel}>
                  <PcItemSelectControl
                    value={selectableValue}
                    options={options}
                    onChange={(val) => setSelectableValue(val)}
                  />
                </PcItemFormGroup>
              )}
              {itemData.is_open && (
                <PcItemFormGroup paramType="open-param" label={itemData.open_parameters_label[0]}>
                  <PcItemInputControl
                    paramType="open-price-input"
                    value={openParamValue}
                    onChange={(e) => setOpenParamValue(e.target.value)}
                  />
                </PcItemFormGroup>
              )}
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

            <div className="d-flex flex-wrap justify-content-end gap-3">
              <PcItemFormGroup paramType="discount" label="Discount">
                <PcItemInputControl
                  paramType="discount"
                  value={discount}
                  onChange={(e) => setDiscount(e.target.value)}
                />
              </PcItemFormGroup>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
