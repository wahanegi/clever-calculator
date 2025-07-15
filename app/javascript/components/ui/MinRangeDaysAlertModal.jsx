import React from "react";
import { AlertModal } from "../shared/AlertModal";

const RangeTooShortAlertModal = ({ isOpen, setIsOpen }) =>
    <AlertModal
        title={'Range Too Short'}
        bodyText={'Please select more than 1 day.'}
        show={isOpen}
        onCancel={() => setIsOpen(false)}
        showActions={false} />


export default RangeTooShortAlertModal