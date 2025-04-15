import React from 'react'
import { PcIcon } from './PcIcon'

export const PcBtnAddRemoveNotes = ({
  title = '',
  iconName = '',
  className = '',
  onClick,
  disabled = false,
}) => {
  const handleClick = (e) => {
    e.stopPropagation()
    if (disabled) return
    onClick?.(e)

    // TODO: delete after developed logic
    console.log('handleClick')
  }

  const handleKeyDown = (e) => {
    e.stopPropagation()
    if (disabled) return
    if (e.key === 'Enter' || e.key === ' ') {
      e.preventDefault()
      onClick?.(e)
    }
  }

  const textColor = disabled ? '#666666' : '#2487bf'

  return (
    <div
      role="button"
      tabIndex={disabled ? -1 : 0}
      aria-disabled={disabled}
      onClick={handleClick}
      onKeyDown={handleKeyDown}
      className={`d-flex align-items-center gap-2 p-0 fs-10 fw-bold lh-lg bg-transparent ${className}`}
      style={{
        cursor: disabled ? 'default' : 'pointer',
        color: textColor,
        userSelect: 'none',
      }}
    >
      {title}
      {!!iconName && <PcIcon name={iconName} />}
    </div>
  )
}
