import React from 'react'
import { IMAGE_ASSETS } from '../shared'

export const PcIcon = ({ name, alt, ...props }) => {
  const icon = IMAGE_ASSETS.ICONS[name]

  if (!icon) {
    throw new Error(`Icon ${name} not found in IMAGE_ASSETS.ICONS`)
  }

  return <img src={icon} alt={alt || name} {...props} />
}
