import React from 'react'
import { Button } from 'react-bootstrap'

export const PcButton = ({
                           children = 'Primary button',
                           variant = 'primary',
                           className = '',
                           ...props
                         }) => {
  return (
    <Button
      className={`d-flex justify-content-center align-items-center gap-1 rounded-3 fw-bold pc-btn ${variant} ${className}`}
      {...props}
    >
      {children}
    </Button>
  )
}
