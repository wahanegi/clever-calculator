import React from 'react'
import { Button } from 'react-bootstrap'
import { PcIcon } from './PcIcon'

export const PcExtraActionBtn = ({
  children,
  className = '',
  disabled = false,
  onClick,
  type = 'button',
  variant = 'outline-primary',
  iconName = '',
}) => {
  return (
    <div
      onClick={onClick}
      className={`d-flex align-items-center gap-2 p-0 fs-10 fw-bold lh-lg pc-pointer ${className}`}
    >
      <Button
        type={type}
        variant={variant}
        disabled={disabled}
        className={`border-0 p-0 fs-10 fw-bold lh-lg bg-transparent text-primary ${className}`}
      >
        {children}
      </Button>
      {!!iconName && <PcIcon name={iconName} />}
    </div>
  )
}
