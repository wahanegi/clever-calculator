import React from 'react'
import { Form } from 'react-bootstrap'

export const PcItemTextareaControl = ({
  value,
  onChange,
  placeholder = '',
  rows = 3,
  ...props
}) => {
  return (
    <Form.Control
      as="textarea"
      value={value}
      onChange={onChange}
      placeholder={placeholder}
      rows={rows}
      {...props}
    />
  )
}
