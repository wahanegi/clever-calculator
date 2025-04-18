import React from 'react'
import { Col, Row } from 'react-bootstrap'
import { PcItemFormGroup, PcItemInputControl } from '../ui'

export const ItemTotalPrice = ({
  labelOne = 'Price',
  labelTwo = 'Discounted price',
  labelThree = 'Discount',
  itemTypeOne = 'price',
  itemTypeTwo = 'discounted-price',
  itemTypeThree = 'discount',
  className,
}) => {
  return (
    <div className={`px-0 ${className}`}>
      <Row className={'g-3 justify-content-end'}>
        <Col sm={'auto'}>
          <PcItemFormGroup itemType={itemTypeOne} label={labelOne}>
            <PcItemInputControl itemType={itemTypeOne} />
          </PcItemFormGroup>
        </Col>
        <Col sm={'auto'}>
          <PcItemFormGroup itemType={itemTypeTwo} label={labelTwo}>
            <PcItemInputControl itemType={itemTypeTwo} />
          </PcItemFormGroup>
        </Col>
      </Row>

      <Row className={'g-3 justify-content-end'}>
        <Col sm={'auto'}>
          <PcItemFormGroup itemType={itemTypeThree} label={labelThree}>
            <PcItemInputControl itemType={itemTypeThree} />
          </PcItemFormGroup>
        </Col>
      </Row>
    </div>
  )
}
