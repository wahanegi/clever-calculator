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
           contentClassName={'border-1 border-primary p-4 p-xxl-7 p-xl-5 bg-light'}
           {...props}>
      <Modal.Header closeButton className={'p-0 border-0'} />
      <Modal.Body className={'d-flex flex-column align-items-center justify-content-center p-0 mt-3 mt-xxl-6 mt-xl-4'}>
        <PcIcon name={'checkCircle'} className={'mb-3 mb-xxl-7 mb-xl-5 mb-lg-4'} />
        <h2 className={'mb-5 mb-xxl-10 mb-xl-7 mb-lg-5 fw-bold text-center'}>
          Your file downloaded
         <div className={'text-primary mt-3 mt-xxl-5 mt-xl-4'}>successfully</div>
        </h2>

        <div className={'mb-3 mb-xxl-8 mb-xl-6 mb-lg-5'}>
          <img src={IMAGE_ASSETS.BACKGROUNDS.manCalculator} className={'img-fluid'} alt={'Downloaded file'} />
        </div>
      </Modal.Body>
    </Modal>
  )
}
