import React from 'react'

export const PcTransparentButton = ({ children, className, ...props }) =>
  (<button className={`bg-transparent rounded-0 border-0 p-0 m-0 ${className}`} {...props}>
    {children}
  </button>)