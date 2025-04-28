import React from 'react'
import { PcIcon } from './PcIcon'
import { Form } from 'react-bootstrap'

export const PcLogoUploader = ({ id, logo, error, ...props }) => {
  const logoDisplay = logo ?
    (<img src={logo}
          alt="Logo"
          className={'pc-logo-uploader-display object-fit-contain'} />)
    : (<PcIcon name="placeholder" alt="Placeholder Logo" />)

  return (
    <Form.Group className="d-flex flex-column">
      <Form.Label htmlFor={id}
                  className={'pc-logo-uploader m-0 d-flex justify-content-center align-items-center bg-white border rounded border-primary p-1'}>
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
  )
}