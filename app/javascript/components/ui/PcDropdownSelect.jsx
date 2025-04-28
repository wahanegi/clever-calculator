import React, { useState } from 'react'
import { Form } from 'react-bootstrap'
import { Typeahead } from 'react-bootstrap-typeahead'
import { normalizeName } from '../utils'
import { PcIcon } from './PcIcon'

export const PcDropdownSelect = ({
  id,
  options,
  placeholder,
  height,
  value,
  label,
  error,
  maxResults = 5,
  hasIcon = false,
  onChange,
  onInputChange,
  ...props
}) => {
  const [isMenuOpen, setIsMenuOpen] = useState(false)

  const selectedOption =
    options.find((opt) => opt.value === value) || (value ? { value, label: value, customOption: true } : null)

  const handleFilterBy = (option, props) => {
    const inputValue = normalizeName(props.text)
    return normalizeName(option.label).includes(inputValue)
  }

  const handleOpenMenu = (e) => {
    setIsMenuOpen((prev) => !prev)
  }

  const handleFocus = (e) => {
    setIsMenuOpen(true)
  }

  const handleBlur = (e) => {
    setIsMenuOpen(false)
  }

  const handleChenge = (selected) => {
    onChange(selected)

    if (selected.length !== 0) setIsMenuOpen(false)
  }

  const handleInputChange = (t, e) => {
    onInputChange(t, e)
    if (t) setIsMenuOpen(true)
  }

  const DropdownToggleIcon = () => (
    <div className="pc-typeahead-toggle position-absolute end-0 top-0 h-100" onClick={handleOpenMenu}>
      <div className={'d-flex justify-content-start align-items-center h-100'}>
        <PcIcon
          name={isMenuOpen ? 'arrowUp' : 'arrowDown'}
          alt={isMenuOpen ? 'Arrow pointing up' : 'Arrow pointing down'}
        />
      </div>
    </div>
  )

  return (
    <Form.Group controlId={id}>
      <div className="pc-typeahead-customer-info position-relative">
        <Typeahead
          id={id}
          options={options}
          placeholder={placeholder}
          filterBy={handleFilterBy}
          allowNew
          newSelectionPrefix="Add new customer: "
          className="pc-icon-reserve-place border border-primary rounded-1"
          style={{ height }}
          selected={selectedOption ? [selectedOption] : []}
          maxResults={maxResults}
          paginate={false}
          open={isMenuOpen}
          onMenuToggle={(isOpen) => setIsMenuOpen(isOpen)}
          onFocus={handleFocus}
          onBlur={handleBlur}
          onChange={handleChenge}
          onInputChange={handleInputChange}
          {...props}
        />
        <Form.Label className="border-label fw-bold fs-11 lh-sm px-1">{label}</Form.Label>
        {hasIcon && <DropdownToggleIcon />}
      </div>
      {error && <div className="text-danger fs-12">{error}</div>}
    </Form.Group>
  )
}
