import React from 'react'
import { Form } from 'react-bootstrap'

export const PcItemInputControl = ({
  type,
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

  const inputType = type || (isDisabled ? 'text' : 'number')

  return (
    <Form.Control
      type={inputType}
      value={value}
      onChange={onChange}
      placeholder={placeholder}
      disabled={isDisabled}
      className="nospin fs-10 pc-lh-xl"
      onWheel={(e) => e.target.blur()}
      onKeyDown={(e) => {
        if (e.key === 'ArrowUp' || e.key === 'ArrowDown') {
          e.preventDefault()
        }
      }}
      {...props}
    />
  )
}
