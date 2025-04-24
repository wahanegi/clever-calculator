import React from 'react'
import { PcIcon } from './PcIcon'
import { Form } from 'react-bootstrap'

export const PcLogoUploader = ({ id, logo, error, ...props }) => {
  const logoDisplay = logo ?
    <img src={logo} alt="Logo"
         className={'object-fit-contain w-100 h-100'} />
    : <PcIcon name="placeholder" alt="Placeholder Logo" />

  return <Form.Group className="d-flex flex-column">
    <Form.Label htmlFor={id}
                className={'m-0 d-flex justify-content-center align-items-center h-100 w-100 bg-white border rounded border-primary p-1'}
                style={{ flexBasis: '117px', maxHeight: '117px' }}
                column={'sm'}>
      {logoDisplay}
    </Form.Label>
    <Form.Control
      id={id}
      className={'d-none'}
      type={'file'}
      {...props}
    />
    {error && <div className="text-danger fs-12">{error}</div>}
  </Form.Group>
}