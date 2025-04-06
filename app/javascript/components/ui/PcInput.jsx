import React from 'react'
import { Form } from 'react-bootstrap'

export const PcInput = ({ id, type = 'text', placeholder, label, options = [], as, height, value, onChange, error }) => {
  return (
    <Form.Group controlId={id} className="position-relative">
      <Form.Control
        as={as}
        type={type}
        placeholder={placeholder}
        className="border border-primary rounded-1 py-4"
        style={{ height }}
        value={value}
        onChange={onChange}
      />
      <Form.Label className="border-label fw-bold fs-11 lh-sm px-1">{label}</Form.Label>
      {error && <div className="text-danger fs-12">{error}</div>}
    </Form.Group>
  )
}
