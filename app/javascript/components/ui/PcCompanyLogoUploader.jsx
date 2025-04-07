import React from 'react'
import { PcIcon } from './PcIcon'
import { Form } from 'react-bootstrap'

export const PcCompanyLogoUploader = ({ id, logo, alt, ...props }) => {
  const logoDisplay = logo ?
    <img src={logo}
         alt={alt}
         style={{ height: '100%', width: '100%' }} />
    : <PcIcon name="placeholder" alt="Placeholder Logo" />

  return <Form.Group controlId={id} className="w-100 h-100 bg-white border rounded border-primary p-1">
    <Form.Label className={'m-0 d-flex justify-content-center align-items-center h-100'} column={'sm'}>
      {logoDisplay}
      <Form.Control
        className={'d-none'}
        type={'file'}
        accept={'image/jpeg,image/png'}
        {...props}
      />
    </Form.Label>
  </Form.Group>
}