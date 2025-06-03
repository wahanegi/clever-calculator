import React from 'react'
import { Form } from 'react-bootstrap'

export const PcItemFormGroup = ({
  children,
  paramType = 'price',
  label = 'Price',
  suffixLeft = '$',
  suffixRight = '%',
  className = '',
}) => {
  const isSuffixLeft =
    paramType === 'price' ||
    paramType === 'discounted-price' ||
    paramType === 'original-cost' ||
    paramType === 'open-price-input'
  const isSuffixRight = paramType === 'discount'

  return (
    <Form.Group className={`position-relative pc-item-input ${paramType} ${className}`} title={label}>
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
