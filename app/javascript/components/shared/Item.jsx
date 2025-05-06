import React, { useState } from 'react'
import { Col, Row } from 'react-bootstrap'
import { PcItemFormGroup, PcItemInputControl, PcItemSelectControl } from '../ui'
import { discountedPrice, getItemTypeConditions, getOptionsFromPricingOptions } from '../utils'

// TODO: will be replaced with value fetch from backend
const DUMMY_PRICE = 7777

export const Item = ({ itemData, className }) => {
  const fixedValue = parseFloat(Object.values(itemData.fixed_parameters)[0])
  const fixedValueLabel = Object.keys(itemData.fixed_parameters)[0]
  const { options, valueLabel } = getOptionsFromPricingOptions(itemData.pricing_options)
  const selectableParamLabel = Object.keys(itemData.pricing_options || {})[0] || ''

  const [openParamValue, setOpenParamValue] = useState('')
  const [selectableValue, setSelectableValue] = useState('')
  const [discount, setDiscount] = useState('')

  const { isItemFixed, isItemOpen, isItemSelectableOptions, isShowSimpleParams, isShowCombinedParams } =
    getItemTypeConditions(itemData)

  console.log(itemData)
  return (
    <div>
      {isShowSimpleParams && (
        <div className={`d-flex flex-column gap-3 px-0 ${className}`}>
          <Row className={'g-3 justify-content-end'}>
            {isItemFixed && (
              <Col sm={'auto'}>
                <PcItemFormGroup paramType="price" label="Price">
                  <PcItemInputControl paramType="price" value={fixedValue} />
                </PcItemFormGroup>
              </Col>
            )}
            <Col sm={'auto'}>
              <PcItemFormGroup paramType="discounted-price" label="Discounted price">
                <PcItemInputControl paramType="discounted-price" value={discountedPrice(DUMMY_PRICE, discount)} />
              </PcItemFormGroup>
            </Col>
          </Row>

          <Row className={'g-3 justify-content-end'}>
            {isItemOpen && (
              <Col sm={'auto'}>
                <PcItemFormGroup paramType="open-price-input" label={itemData.open_parameters_label[0]}>
                  <PcItemInputControl
                    paramType="open-price-input"
                    value={openParamValue}
                    onChange={(e) => setOpenParamValue(e.target.value)}
                  />
                </PcItemFormGroup>
              </Col>
            )}
            {isItemSelectableOptions && (
              <Col sm={'auto'}>
                <PcItemFormGroup paramType="selectable-param" label={selectableParamLabel}>
                  <PcItemSelectControl
                    value={selectableValue}
                    options={options}
                    onChange={(val) => setSelectableValue(val)}
                  />
                </PcItemFormGroup>
              </Col>
            )}
            <Col sm={'auto'}>
              <PcItemFormGroup paramType="discount" label="Discount">
                <PcItemInputControl
                  paramType="discount"
                  value={discount}
                  onChange={(e) => setDiscount(e.target.value)}
                />
              </PcItemFormGroup>
            </Col>
          </Row>
        </div>
      )}

      {isShowCombinedParams && (
        <div className={`d-flex justify-content-between`}>
          {/* Left Side */}
          <div className={`d-flex flex-column gap-3 px-0 ${className}`}>
            <Row className={'g-3'}>
              {itemData.is_selectable_options && (
                <Col sm={'auto'}>
                  <PcItemFormGroup label={valueLabel}>
                    <PcItemInputControl
                      paramType="open-price-input"
                      value={selectableValue}
                      onChange={(e) => setOpenParamValue(e.target.value)}
                      disabled={true}
                    />
                  </PcItemFormGroup>
                </Col>
              )}
              {itemData.is_fixed && (
                <Col sm={'auto'}>
                  <PcItemFormGroup label={fixedValueLabel}>
                    <PcItemInputControl paramType="price" value={fixedValue} disabled={true} />
                  </PcItemFormGroup>
                </Col>
              )}
            </Row>
            <Row className={'g-3'}>
              {itemData.is_selectable_options && (
                <Col sm={'auto'}>
                  <PcItemFormGroup paramType="selectable-param" label={selectableParamLabel}>
                    <PcItemSelectControl
                      value={selectableValue}
                      options={options}
                      onChange={(val) => setSelectableValue(val)}
                    />
                  </PcItemFormGroup>
                </Col>
              )}
              {itemData.is_open && (
                <Col sm={'auto'}>
                  <PcItemFormGroup paramType="open-param" label={itemData.open_parameters_label[0]}>
                    <PcItemInputControl
                      paramType="open-price-input"
                      value={openParamValue}
                      onChange={(e) => setOpenParamValue(e.target.value)}
                    />
                  </PcItemFormGroup>
                </Col>
              )}
            </Row>
          </div>

          {/* Right Side */}
          <div className={`d-flex flex-column gap-3 px-0 ${className}`}>
            <Row className={'g-3 justify-content-end'}>
              <Col sm={'auto'}>
                <PcItemFormGroup paramType="price" label="Price">
                  {/*Field price*/}
                  <PcItemInputControl paramType="price" value={DUMMY_PRICE} />
                </PcItemFormGroup>
              </Col>
              <Col sm={'auto'}>
                <PcItemFormGroup paramType="discounted-price" label="Discounted price">
                  {/*Field discounted-price */}
                  <PcItemInputControl paramType="discounted-price" value={DUMMY_PRICE} />
                </PcItemFormGroup>
              </Col>
            </Row>

            <Row className={'g-3 justify-content-end'}>
              <Col sm={'auto'}>
                <PcItemFormGroup paramType="discount" label="Discount">
                  {/*Field discount */}
                  <PcItemInputControl
                    paramType="discount"
                    value={discount}
                    onChange={(e) => setDiscount(e.target.value)}
                  />
                </PcItemFormGroup>
              </Col>
            </Row>
          </div>
        </div>
      )}
    </div>
  )
}
