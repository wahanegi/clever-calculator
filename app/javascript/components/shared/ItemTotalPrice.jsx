import React, { useEffect, useState } from 'react'
import { Col, Row } from 'react-bootstrap'
import { PcItemFormGroup, PcItemInputControl, PcItemSelectControl } from '../ui'
import { formatPrice, getOptionsFromPricingOptions } from '../utils'

export const ItemTotalPrice = ({
  itemData,

  labelOne = 'Price',
  itemTypeOne = 'price',

  labelTwo = 'Discounted price',
  itemTypeTwo = 'discounted-price',

  labelThree = 'Discount',
  itemTypeThree = 'discount',

  labelFour = 'Additional fees',
  itemTypeFour = 'additional-fees',

  labelFive = Object.keys(itemData.pricing_options || {})[0] || '',
  itemTypeFive = 'tier',

  className,
}) => {
  const fixedValue = Number(itemData.fixed_parameters.Price)
  const options = getOptionsFromPricingOptions(itemData.pricing_options)

  const [openParamValue, setOpenParamValue] = useState('')
  const [selectableValue, setSelectableValue] = useState('')
  const [discount, setDiscount] = useState('')
  const [discounted, setDiscounted] = useState(fixedValue)

  const isItemFixed = Boolean(itemData.is_fixed & !itemData.is_open & !itemData.is_selectable_options)
  const isItemOpen = Boolean(!itemData.is_fixed & itemData.is_open & !itemData.is_selectable_options)
  const isItemSelectableOptions = Boolean(!itemData.is_fixed & !itemData.is_open & itemData.is_selectable_options)

  useEffect(() => {
    const discountValue = Number(discount)
    const baseValue = isItemOpen
      ? Number(openParamValue)
      : isItemSelectableOptions
        ? Number(selectableValue)
        : fixedValue
    const calculatedValue = baseValue - (baseValue * discountValue) / 100

    setDiscounted(discountValue > 0 ? calculatedValue : baseValue)
  }, [discount, fixedValue, openParamValue, selectableValue, isItemOpen, isItemSelectableOptions])

  return (
    <div className={`d-flex flex-column gap-3 px-0 ${className}`}>
      <Row className={'g-3 justify-content-end'}>
        {isItemFixed && (
          <Col sm={'auto'}>
            <PcItemFormGroup itemType={itemTypeOne} label={labelOne}>
              <PcItemInputControl itemType={itemTypeOne} value={fixedValue} />
            </PcItemFormGroup>
          </Col>
        )}
        <Col sm={'auto'}>
          <PcItemFormGroup itemType={itemTypeTwo} label={labelTwo}>
            <PcItemInputControl itemType={itemTypeTwo} value={formatPrice(discounted)} />
          </PcItemFormGroup>
        </Col>
      </Row>

      <Row className={'g-3 justify-content-end'}>
        <Col sm={'auto'}>
          {isItemOpen && (
            <PcItemFormGroup itemType={itemTypeFour} label={labelFour}>
              <PcItemInputControl
                itemType={itemTypeFour}
                value={openParamValue}
                onChange={(e) => setOpenParamValue(e.target.value)}
              />
            </PcItemFormGroup>
          )}
          {isItemSelectableOptions && (
            <PcItemFormGroup itemType={itemTypeFive} label={labelFive}>
              <PcItemSelectControl
                itemType={itemTypeFive}
                value={selectableValue}
                options={options}
                onChange={(val) => setSelectableValue(val)}
              />
            </PcItemFormGroup>
          )}
        </Col>
        <Col sm={'auto'}>
          <PcItemFormGroup itemType={itemTypeThree} label={labelThree}>
            <PcItemInputControl
              itemType={itemTypeThree}
              value={discount}
              onChange={(e) => setDiscount(e.target.value)}
            />
          </PcItemFormGroup>
        </Col>
      </Row>
    </div>
  )
}
