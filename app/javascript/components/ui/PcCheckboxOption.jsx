import React from 'react'
import { Form } from 'react-bootstrap'

export const PcCheckboxOption = ({ className, ...props }) => (
  <div className={className}>
    <Form.Check type={'checkbox'} {...props} />
  </div>
)

