import React, { useState } from 'react'
import { Form } from 'react-bootstrap'
import { Typeahead } from 'react-bootstrap-typeahead'
import { PcIcon } from './PcIcon'

export const PcDropdownSelect = ({
  id,
  options,
  placeholder,
  onChange,
  onInputChange,
  height,
  value,
  label,
  error,
  maxResults = 5,
  hasIcon = false,
}) => {
  const [isMenuOpen, setIsMenuOpen] = useState(false)
  const [inputValue, setInputValue] = useState('')

  const selectedOption =
    options.find((opt) => opt.value === value) || (value ? { value, label: value, customOption: true } : null)

  const hasMatchingOption = () => {
    const trimmedInput = inputValue.trim().toLowerCase()
    return options.some((option) => option.label.toLowerCase() === trimmedInput)
  }

  return (
    <Form.Group controlId={id} className="position-relative">
      <Typeahead
        id={id}
        options={options}
        placeholder={placeholder}
        onChange={(selected) => {
          if (selected.length > 0) {
            const selectedOption = selected[0]
            const valueToPass = selectedOption.customOption ? selectedOption.label : selectedOption.value
            onChange({ target: { id, value: valueToPass } })
          } else {
            onChange({ target: { id, value: '' } })
          }
        }}
        onInputChange={(text, event) => {
          setInputValue(text)
          if (onInputChange) onInputChange(event)
        }}
        filterBy={(option, props) => {
          const inputValue = props.text.trim().toLowerCase()
          return option.label?.toLowerCase().includes(inputValue)
        }}
        allowNew={!hasMatchingOption()}
        newSelectionPrefix="Add new customer: "
        className="border border-primary rounded-1"
        style={{ height }}
        selected={selectedOption ? [selectedOption] : []}
        maxResults={maxResults}
        paginate={false}
        onMenuToggle={(isOpen) => setIsMenuOpen(isOpen)}
      />
      <Form.Label className="border-label fw-bold fs-11 lh-sm px-1">{label}</Form.Label>
      {hasIcon && (
        <div className="position-absolute end-0 top-50 translate-middle-y pe-3">
          <PcIcon
            name={isMenuOpen ? 'dropdownArrowUp' : 'dropdownArrowDown'}
            alt={isMenuOpen ? 'Arrow pointing up' : 'Arrow pointing down'}
          />
        </div>
      )}
      {error && <div className="text-danger fs-12">{error}</div>}
    </Form.Group>
  )
}
