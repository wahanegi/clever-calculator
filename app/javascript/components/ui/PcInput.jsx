import React from 'react'
import { Form } from 'react-bootstrap'

export const PcInput = ({ id, type = 'text', placeholder, label, options = [], as, height }) => {
  return (
    <Form.Group controlId={id} className="position-relative">
      {type === 'select' ? (
        <Form.Select className="border border-primary rounded-1" style={{ height }}>
          <option>{placeholder}</option>
          {options.map((option) => (
            <option key={option.value} value={option.value}>
              {option.label}
            </option>
          ))}
        </Form.Select>
      ) : (
        <Form.Control
          as={as}
          type={type}
          placeholder={placeholder}
          className="border border-primary rounded-1 py-4"
          style={{ height }}
        />
      )}
      <Form.Label className="border-label fw-bold fs-11 lh-sm px-1">{label}</Form.Label>
    </Form.Group>
  )
}
