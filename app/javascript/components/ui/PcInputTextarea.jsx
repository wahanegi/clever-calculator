import React from 'react'
import { Form } from 'react-bootstrap'

export const PcInputTextarea = ({ id, label, error, className, ...props }) => {
  return (
    <Form.Group controlId={id} className="position-relative border border-primary rounded-1 py-2 px-1 bg-white pc-input-textarea">
      <Form.Control
        as="textarea"
        className={`border-0 rounded-0 py-3 ${className || ''}`}
        {...props}
      />
      <Form.Label className="border-label fw-bold fs-11 lh-sm px-1">{label}</Form.Label>
      {error && <div className="text-danger fs-12">{error}</div>}
    </Form.Group>
  )
}