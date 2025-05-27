import React from 'react'
import { AlertModal } from '../shared/AlertModal'
import { ROUTES } from '../shared'
import { useAppHooks } from '../hooks'
export const CancelQuoteAlertModal = ({ setIsShowCancelQuoteAlertModal, isShowCancelQuoteAlertModal }) => {
  const { navigate } = useAppHooks()

  const handleCancel = () => {
    setIsShowCancelQuoteAlertModal(false)
  }

  const handleConfirm = () => {
    setIsShowCancelQuoteAlertModal(false)

    navigate(ROUTES.CUSTOMER_INFO)
  }

  return (
    <AlertModal
      show={isShowCancelQuoteAlertModal}
      onCancel={handleCancel}
      onConfirm={handleConfirm}
      confirmButtonText={'Go back'}
      title={'Are you sure?'}
      bodyText={
        'Do you really want to go back and cancel the current quote? This action will discard all progress and start a new quote.'
      }
    />
  )
}
