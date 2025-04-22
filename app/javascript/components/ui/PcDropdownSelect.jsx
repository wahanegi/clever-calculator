import React, { useState } from 'react'
import { Form } from 'react-bootstrap'
import { Typeahead } from 'react-bootstrap-typeahead'
import { normalizeName } from '../utils'

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
    const normalizedInput = normalizeName(inputValue)
    return options.some((option) => normalizeName(option.label) === normalizedInput)
  }

  const handleChange = (selected) => {
    if (selected.length > 0) {
      const selectedOption = selected[0]
      const valueToPass = selectedOption.customOption ? selectedOption.label : selectedOption.value
      onChange({ target: { id, value: valueToPass } })
    } else {
      onChange({ target: { id, value: '' } })
    }
  }

  const handleInputChange = (text, event) => {
    setInputValue(text)
    if (onInputChange) onInputChange(event)
  }

  const handleFilterBy = (option, props) => {
    const inputValue = normalizeName(props.text)
    return normalizeName(option.label).includes(inputValue)
  }

  return (
    <Form.Group controlId={id} className="pc-typeahead position-relative">
      <Typeahead
        id={id}
        options={options}
        placeholder={placeholder}
        onChange={handleChange}
        onInputChange={handleInputChange}
        filterBy={handleFilterBy}
        allowNew={!hasMatchingOption()}
        newSelectionPrefix="Add new customer: "
        className={`${hasIcon ? isMenuOpen ? 'pc-typeahead-arrow-up' : 'pc-typeahead-arrow-down' : ''} border border-primary rounded-1`}
        style={{ height }}
        selected={selectedOption ? [selectedOption] : []}
        maxResults={maxResults}
        paginate={false}
        onMenuToggle={(isOpen) => setIsMenuOpen(isOpen)}
      />
      <Form.Label className="border-label fw-bold fs-11 lh-sm px-1">{label}</Form.Label>
      {error && <div className="text-danger fs-12">{error}</div>}
    </Form.Group>
  )
}
