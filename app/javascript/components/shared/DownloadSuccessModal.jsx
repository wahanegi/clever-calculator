import React from 'react'
import { PcIcon } from '../ui'
import { Modal } from 'react-bootstrap'
import { IMAGE_ASSETS } from './constants'

export const DownloadSuccessModal = ({ show, onHide, props }) => {
  return (
    <Modal centered
           show={show}
           onHide={onHide}
           dialogClassName={'pc-mw-524'}
           contentClassName={'border-1 border-primary py-7 px-8 bg-light'}
           {...props}>
      <Modal.Header closeButton className={'p-0 border-0'} />
      <Modal.Body className={'d-flex flex-column align-items-center justify-content-center p-0 mt-9'}>
        <PcIcon name={'checkCircle'} className={'mb-10'} />
        <h2 className={'mb-17 fw-bold text-center'}>
          Your file downloaded
         <div className={'text-primary mt-7'}>successfully</div>
        </h2>

        <div className={'mb-12'}>
          <img src={IMAGE_ASSETS.BACKGROUNDS.manCalculator} alt={'Downloaded file'} />
        </div>
      </Modal.Body>
    </Modal>
  )
}
