import React from 'react'
import { Form } from 'react-bootstrap'

export const PcItemInputControl = ({
  type = 'number',
  paramType = 'price',
  value,
  onChange,
  placeholder = '0',
  disabled = false,
  ...props
}) => {
  const isDisabled =
    paramType === 'price' ||
    paramType === 'discounted-price' ||
    paramType === 'original-cost' ||
    paramType === 'select-price-value'

  return (
    <Form.Control
      type={type}
      value={value}
      onChange={onChange}
      placeholder={placeholder}
      disabled={isDisabled}
      min={0}
      className="nospin fs-10 pc-lh-xl"
      {...props}
    />
  )
}
