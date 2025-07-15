import React from 'react'
import { MAX_DECIMAL_14_2 } from '../shared'
import { AlertModal } from '../shared/AlertModal'


export const OverLimitAlertModal = ({ isOverPriceLimit, setIsOverPriceLimit }) => {
  const handleHide = () => {
    setIsOverPriceLimit(false)
  }

  return (
    <AlertModal
      show={isOverPriceLimit}
      onCancel={handleHide}
      showActions={false}
      title={'Total Price is Too High'}
      bodyText={<>The total price exceeds maximum allowed value of ${MAX_DECIMAL_14_2}. <br/> Please adjust your item input value.</>}
    />
  )
}
