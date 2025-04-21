import React from 'react'
import { PcIcon } from './PcIcon'
import { Form } from 'react-bootstrap'

export const PcCompanyLogoUploader = ({ id, logo, error, ...props }) => {
  const logoDisplay = logo ?
    <img src={logo}
         alt="Company Logo"
         className={'img-fluid'} />
    : <PcIcon name="placeholder" alt="Placeholder Logo" />

  return <Form.Group className="d-flex flex-column w-100 h-100">
    <Form.Label htmlFor={id}
                className={'m-0 d-flex justify-content-center align-items-center h-100 w-100 bg-white border rounded border-primary p-1'}
                column={'sm'}>
      {logoDisplay}
    </Form.Label>
    <Form.Control
      id={id}
      className={'d-none'}
      type={'file'}
      accept={'image/jpeg,image/png'}
      {...props}
    />
    {error && <div className="text-danger fs-12">{error}</div>}
  </Form.Group>
}