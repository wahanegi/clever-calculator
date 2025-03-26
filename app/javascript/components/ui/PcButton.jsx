import React from 'react'
import { Button } from 'react-bootstrap'

export const PcButton = ({ children = 'Primary button', variant = 'primary', className = '', ...props }) => {
  return (
    <Button
      className={`pc-btn d-flex justify-content-center align-items-center gap-1 rounded-3 border-2 fw-bold ${variant} ${className}`}
      {...props}
    >
      {children}
    </Button>
  )
}
