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
                                   hasIcon = false,
                                   onChange,
                                   onInputChange,
                                   onClearInput,
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

  const handleChange = (selected) => {
    onChange(selected)

    if (selected.length !== 0) setIsMenuOpen(false)
  }

  const handleInputChange = (t, e) => {
    onInputChange(t, e)

    if (t) setIsMenuOpen(true)
  }

  const handleClick = (e) => {
    setIsMenuOpen(true)
  }

  const TransparentButton = ({ children, className, ...props }) =>
    (<button className={`bg-transparent rounded-0 border-0 p-0 m-0 ${className}`} {...props}>
      {children}
    </button>)

  const TypeaheadControls = () =>
    (<div className="pc-typeahead-controls position-absolute end-0 top-0 h-100 d-flex flex-row">
      <TransparentButton onClick={onClearInput} className={'pc-typeahead-button'}>
        <PcIcon name={'cross'} alt={'Cross'} className={'pc-icon-cross'} />
      </TransparentButton>
      <TransparentButton onClick={handleOpenMenu} className={'pc-typeahead-button'}>
        <PcIcon
          name={isMenuOpen ? 'arrowUp' : 'arrowDown'}
          alt={isMenuOpen ? 'Arrow pointing up' : 'Arrow pointing down'}
        />
      </TransparentButton>
    </div>)

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
          className="pc-icon-reserve-place border border-primary rounded-1 bg-white"
          style={{ height }}
          selected={selectedOption ? [selectedOption] : []}
          paginate={false}
          open={isMenuOpen}
          onMenuToggle={(isOpen) => setIsMenuOpen(isOpen)}
          onFocus={handleFocus}
          onBlur={handleBlur}
          onChange={handleChange}
          onInputChange={handleInputChange}
          inputProps={{ onClick: handleClick }}
          {...props}
        />
        <Form.Label className="border-label fw-bold fs-11 lh-sm px-1">{label}</Form.Label>
        {hasIcon && <TypeaheadControls />}
      </div>
      {error && <div className="text-danger fs-12">{error}</div>}
    </Form.Group>
  )
}