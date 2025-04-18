import React from 'react'
import { Form } from 'react-bootstrap'

export const PcItemInputControl = ({
  type = 'number',
  itemType = 'price',
  value,
  onChange,
  placeholder = '0',
  disabled = false,
  ...props
}) => {
  const isDisabled =
    itemType === 'price' || itemType === 'discounted-price' || itemType === 'original-cost'

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
