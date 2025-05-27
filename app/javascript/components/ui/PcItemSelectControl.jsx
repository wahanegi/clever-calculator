import React from 'react'
import { Form } from 'react-bootstrap'

export const PcItemSelectControl = ({ value, onChange, options = [], placeholder = 'Select...', ...props }) => {
  return (
    <Form.Select value={value} onChange={(e) => onChange(e.target.value)} className={'fs-10 pc-lh-xl'} {...props}>
      <option value="">{placeholder}</option>
      {options.map((opt, idx) => (
        <option key={opt.value || idx} value={opt.value}>
          {opt.label || opt.name}
        </option>
      ))}
    </Form.Select>
  )
}
