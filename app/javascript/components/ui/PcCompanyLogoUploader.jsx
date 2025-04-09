import React from 'react'
import { PcIcon } from './PcIcon'
import { Form } from 'react-bootstrap'

export const PcCompanyLogoUploader = ({ id, logo, ...props }) => {
  const logoDisplay = logo ?
    <img src={logo}
         alt="Company Logo"
         className={'img-fluid'} />
    : <PcIcon name="placeholder" alt="Placeholder Logo" />

  return <Form.Group className="w-100 h-100 bg-white border rounded border-primary p-1">
    <Form.Label htmlFor={id} className={'m-0 d-flex justify-content-center align-items-center h-100'} column={'sm'}>
      {logoDisplay}
    </Form.Label>
    <Form.Control
      id={id}
      className={'d-none'}
      type={'file'}
      accept={'image/jpeg,image/png'}
      {...props}
    />
  </Form.Group>
}