import React, { useState } from 'react'
import { Col, Row } from 'react-bootstrap'
import { PcItemFormGroup, PcItemInputControl, PcItemSelectControl } from '../ui'
import { formatPrice, getItemTypeConditions, getOptionsFromPricingOptions } from '../utils'
import { useItemPriceCalculation } from '../hooks'

export const ItemTotalPrice = ({ itemData, className }) => {
  const fixedValue = Number(itemData.fixed_parameters.Price)
  const options = getOptionsFromPricingOptions(itemData.pricing_options)

  const [openParamValue, setOpenParamValue] = useState('')
  const [selectableValue, setSelectableValue] = useState('')
  const [discount, setDiscount] = useState('')
  const selectableNumericValue = Number(selectableValue?.value || selectableValue || 0)

  const { basePrice, discounted } = useItemPriceCalculation({
    fixedValue,
    openParamValue,
    selectableValue: selectableNumericValue,
    discount,
    itemData,
  })

  const {
    isItemFixed,
    isItemOpen,
    isItemSelectableOptions,
    isSelectableOpen,
    isSelectableFixed,
    isFixedOpen,
    isShowSimpleParams,
    isShowCombinedParams,
  } = getItemTypeConditions(itemData)

  // TODO: not all labels exist in data => should add it
  const selectableParamLabel = Object.keys(itemData.pricing_options || {})[0] || ''

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
                <PcItemInputControl paramType="discounted-price" value={formatPrice(discounted)} />
              </PcItemFormGroup>
            </Col>
          </Row>

          <Row className={'g-3 justify-content-end'}>
            {isItemOpen && (
              <Col sm={'auto'}>
                <PcItemFormGroup paramType="additional-fees" label="Additional fees">
                  <PcItemInputControl
                    paramType="additional-fees"
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
            <Row className={'g-3 justify-content-start'}>
              <Col sm={'auto'}>
                {/* Field cost */}
                <PcItemFormGroup paramType="price" label="Acquisition">
                  {!isSelectableOpen && <PcItemInputControl paramType="price" value={fixedValue} />}
                  {isSelectableOpen && <PcItemInputControl paramType="price" value={selectableValue} />}
                </PcItemFormGroup>
              </Col>
            </Row>

            {isFixedOpen && (
              <Row className={'g-3'}>
                <Col sm={'auto'}>
                  <PcItemFormGroup paramType="open-param-secondary" label="Setup">
                    <PcItemInputControl
                      paramType="additional-fees"
                      value={openParamValue}
                      onChange={(e) => setOpenParamValue(e.target.value)}
                    />
                  </PcItemFormGroup>
                </Col>
              </Row>
            )}

            {isSelectableOpen && (
              <Row className={'g-3'}>
                <Col sm={'auto'}>
                  <PcItemFormGroup paramType="selectable-param-secondary" label={selectableParamLabel}>
                    {/*Field select */}
                    <PcItemSelectControl
                      value={selectableValue}
                      options={options}
                      onChange={(val) => setSelectableValue(val)}
                    />
                  </PcItemFormGroup>
                </Col>
                <Col sm={'auto'}>
                  <PcItemFormGroup paramType="open-param-secondary" label="Users">
                    {/*Field user */}
                    <PcItemInputControl
                      paramType="additional-fees"
                      value={openParamValue}
                      onChange={(e) => setOpenParamValue(e.target.value)}
                    />
                  </PcItemFormGroup>
                </Col>
              </Row>
            )}

            {isSelectableFixed && (
              <Row className={'g-3'}>
                <Col sm={'auto'}>
                  <PcItemFormGroup paramType="selectable-param-secondary" label={selectableParamLabel}>
                    {/*Field select */}
                    <PcItemSelectControl
                      value={selectableValue}
                      options={options}
                      onChange={(val) => setSelectableValue(val)}
                    />
                  </PcItemFormGroup>
                </Col>
                <Col sm={'auto'}>
                  <PcItemFormGroup paramType="open-param-secondary" label="Setup">
                    {/*Field Setup */}
                    <PcItemInputControl
                      paramType="additional-fees"
                      value={selectableValue}
                      onChange={(e) => setOpenParamValue(e.target.value)}
                      disabled={true}
                    />
                  </PcItemFormGroup>
                </Col>
              </Row>
            )}
          </div>

          {/* Right Side */}
          <div className={`d-flex flex-column gap-3 px-0 ${className}`}>
            <Row className={'g-3 justify-content-end'}>
              <Col sm={'auto'}>
                <PcItemFormGroup paramType="price" label="Price">
                  {/*Field price*/}
                  <PcItemInputControl paramType="price" value={formatPrice(basePrice)} />
                </PcItemFormGroup>
              </Col>
              <Col sm={'auto'}>
                <PcItemFormGroup paramType="discounted-price" label="Discounted price">
                  {/*Field discounted-price */}
                  <PcItemInputControl paramType="discounted-price" value={formatPrice(discounted)} />
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
