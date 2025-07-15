import React from 'react'
import { Button, Modal } from 'react-bootstrap'
import { PcIcon } from '../ui'

export const AlertModal = ({
                             show,
                             onCancel,
                             onConfirm,
                             confirmButtonText,
                             cancelButtonText = 'Cancel',
                             title,
                             bodyText,
                             showActions = true,
                             props,
                           }) => {
  const ActionControls = () => (
    showActions &&<div className={'d-flex justify-content-center align-content-center gap-8 mt-10'}>
      <Button variant="primary"
              className={'pc-btn text-lato'}
              onClick={onConfirm}>{confirmButtonText}</Button>
      <Button variant="outline-primary"
              className={'pc-btn border-1 text-lato'}
              onClick={onCancel}>{cancelButtonText}</Button>
    </div>
  )

  return (
    <Modal centered
           show={show}
           onHide={onCancel}
           dialogClassName={'pc-mw-524'}
           contentClassName={'border-1 border-primary py-9 px-8'}
           {...props}>
      <Modal.Header closeButton className={'p-0 border-0'}></Modal.Header>
      <Modal.Body className={'d-flex flex-column align-items-center justify-content-center p-0'}>
        <PcIcon name={'alert'} className={'mb-4'} />

        {title && <h4 className={'mb-6 fw-bold'}>{title}</h4>}
        <p className={'text-center'}>{bodyText}</p>

        <ActionControls />
      </Modal.Body>
    </Modal>
  )
}
