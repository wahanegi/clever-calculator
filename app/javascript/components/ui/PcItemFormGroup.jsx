import React from 'react'
import { Form } from 'react-bootstrap'

export const PcItemFormGroup = ({
  children,
  itemType = 'price',
  label = 'Price',
  suffixLeft = '$',
  suffixRight = '%',
  className = '',
}) => {
  const isSuffixLeft =
    itemType === 'price' ||
    itemType === 'discounted-price' ||
    itemType === 'original-cost' ||
    itemType === 'open-cost' ||
    itemType === 'additional-fees'
  const isSuffixRight = itemType === 'discount'

  return (
    <Form.Group className={`position-relative pc-item-input ${itemType} ${className}`}>
      <Form.Label className="pc-label position-absolute top-0 translate-middle-y px-1 py-0 bg-white text-gray-750">
        {label}
      </Form.Label>

      {children}

      {isSuffixLeft && (
        <span className="pc-suffix pc-suffix-left position-absolute top-50 translate-middle-y">{suffixLeft}</span>
      )}

      {isSuffixRight && (
        <span className="pc-suffix pc-suffix-right position-absolute top-50 translate-middle-y">{suffixRight}</span>
      )}
    </Form.Group>
  )
}
