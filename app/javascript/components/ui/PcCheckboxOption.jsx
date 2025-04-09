import React from 'react'
import { Form } from 'react-bootstrap'

export const PcCheckboxOption = ({ option, isSelected, toggleSelection }) => {
  const checked = isSelected(option)
  const handleOnChange = () => toggleSelection(option)

  return (
    <div
      onClick={(e) => {
        e.stopPropagation()
        toggleSelection(option)
      }}
      className={'d-flex align-items-center px-2 py-1 w-100 pc-pointer'}
    >
      <Form.Check
        type={'checkbox'}
        label={option.label}
        checked={checked}
        onChange={handleOnChange}
        className={'m-0 pc-pointer'}
      />
    </div>
  )
}
