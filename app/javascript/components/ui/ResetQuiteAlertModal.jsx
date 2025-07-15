import React from "react"
import { AlertModal } from "../shared/AlertModal"

const ResetQuoteAlertModal = ({ showModal, onCancel, onConfirm }) =>
    <AlertModal show={showModal}
        onCancel={onCancel}
        onConfirm={onConfirm}
        confirmButtonText={'Reset'}
        title={'Are you sure?'}
        bodyText={'Do you really want to reset all selected items? You will be able to start over within this quote.'} />

export default ResetQuoteAlertModal