import React from 'react'
import { Form } from 'react-bootstrap'
import { Typeahead } from 'react-bootstrap-typeahead'

export const PcDropdownSelect = ({ id, options, placeholder, onChange, onInputChange, height, value, label }) => {
  const transformedOptions = options.map((customer) => ({
    value: customer.id,
    label: customer.attributes.company_name,
  }))

  const selectedOption =
    transformedOptions.find((opt) => opt.value === value) ||
    (value ? { value, label: value, customOption: true } : null)

  const renderMenuItemChildren = (option) => {
    return <span>{option.label}</span>
  }
  return (
    <Form.Group controlId={id} className="position-relative">
      <Typeahead
        id={id}
        options={transformedOptions}
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
        onInputChange={(text) => onInputChange && onInputChange(text)}
        filterBy={(option, props) => {
          const inputValue = props.text.trim().toLowerCase()
          return option.label?.toLowerCase().includes(inputValue)
        }}
        allowNew
        newSelectionPrefix="Add new customer: "
        className="border border-primary rounded-1"
        style={{ height }}
        selected={selectedOption ? [selectedOption] : []}
        renderMenuItemChildren={renderMenuItemChildren}
      />
      <Form.Label className="border-label fw-bold fs-11 lh-sm px-1">{label}</Form.Label>
    </Form.Group>
  )
}
