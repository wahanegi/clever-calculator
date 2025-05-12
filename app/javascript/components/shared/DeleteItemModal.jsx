import React from 'react'
import { Button, Modal } from 'react-bootstrap'
import { PcIcon } from '../ui'

export const DeleteItemModal = ({show, onHide, onConfirmDelete, props}) => {

  return (
    <Modal
      {...props}
      aria-labelledby="contained-modal-title-vcenter"
      centered
      show={show}
      onHide={onHide}
      dialogClassName={'pc-mw-524'}
      contentClassName={'border-1 border-danger py-9 px-8'}
    >
      <Modal.Header closeButton className={'p-0 border-0'}></Modal.Header>
      <Modal.Body className={'d-flex flex-column align-items-center justify-content-center p-0'}>
        <PcIcon name={'trash'} className={'mb-4'} />
        <h4 className={'mb-6 fw-bold'}>Are you sure?</h4>
        <p className={'text-center'}>Do you really want to delete this item from your pricing list?</p>
        <p className={'text-center'}>This process <span className={'fw-bold text-dark-700'}>cannot be undone.</span></p>
        <div className={'d-flex justify-content-center align-content-center gap-8 mt-10'}>
          <Button variant="danger" className={'pc-btn text-lato'} onClick={onConfirmDelete}>
            Delete
          </Button>
          <Button variant="outline-primary" className={'pc-btn border-1 text-lato'} onClick={onHide}>
            Cancel
          </Button>
        </div>
      </Modal.Body>
    </Modal>
  )
}
