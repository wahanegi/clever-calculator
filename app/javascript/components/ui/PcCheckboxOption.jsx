import React from 'react'
import { Form } from 'react-bootstrap'

export const PcCheckboxOption = ({ option, isSelected, toggleSelection, className }) => {
  const checked = isSelected(option)
  const handleOnChange = () => toggleSelection(option)

  return (
    <div
      onClick={(e) => {
        e.stopPropagation()
        toggleSelection(option)
      }}
      className={className}
    >
      <Form.Check
        type={'checkbox'}
        label={option.label}
        checked={checked}
        onChange={handleOnChange}
      />
    </div>
  )
}
