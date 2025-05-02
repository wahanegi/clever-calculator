import React, { useRef, useState } from 'react'
import { normalizeName } from '../utils'
import { PcIcon } from './PcIcon'
import { Form } from 'react-bootstrap'
import { Typeahead } from 'react-bootstrap-typeahead'
import { PcTransparentButton } from './PcTransparentButton'

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

  const typeaheadRef = useRef(null)

  const selectedOption =
    options.find((opt) => opt.value === value) || (value ? { value, label: value, customOption: true } : null)

  const handleFilterBy = (option, props) => {
    const inputValue = normalizeName(props.text)
    return normalizeName(option.label).includes(inputValue)
  }

  const handleOpenMenu = (e) => {
    if (!isMenuOpen) typeaheadRef.current.focus()
    setIsMenuOpen((prev) => !prev)
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

  const handleClick = () => {
    setIsMenuOpen(!isMenuOpen)
  }

  const TypeaheadControls = () =>
    (<div className="pc-typeahead-controls position-absolute end-0 top-0 h-100 d-flex flex-row">
      <PcTransparentButton onClick={onClearInput} className={'pc-typeahead-button'}>
        <PcIcon name={'cross'} alt={'Cross'} className={'pc-icon-cross'} />
      </PcTransparentButton>
      <PcTransparentButton onClick={handleOpenMenu} className={'pc-typeahead-button'}>
        <PcIcon
          name={isMenuOpen ? 'arrowUp' : 'arrowDown'}
          alt={isMenuOpen ? 'Arrow pointing up' : 'Arrow pointing down'}
        />
      </PcTransparentButton>
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
          onBlur={handleBlur}
          onChange={handleChange}
          onInputChange={handleInputChange}
          inputProps={{ onClick: handleClick }}
          ref={typeaheadRef}
          {...props}
        />

        <Form.Label className="border-label fw-bold fs-11 lh-sm px-1">{label}</Form.Label>

        {hasIcon && <TypeaheadControls />}
      </div>
      {error && <div className="text-danger fs-12">{error}</div>}
    </Form.Group>
  )
}