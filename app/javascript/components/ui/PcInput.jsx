import React from 'react'
import { Form } from 'react-bootstrap'

export const PcInput = ({ id, type = 'text', label, height, error, ...props }) => {
  return (
    <Form.Group controlId={id} className="position-relative">
      <Form.Control
        type={type}
        className="border border-primary rounded-1 py-2"
        style={{ height }}
        {...props}
      />
      <Form.Label className="border-label fw-bold fs-11 lh-sm px-1">{label}</Form.Label>
      {error && <div className="text-danger fs-12">{error}</div>}
    </Form.Group>
  )
}
