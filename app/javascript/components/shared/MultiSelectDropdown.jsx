import React, { useEffect, useRef, useState } from 'react'
import { Form } from 'react-bootstrap'
import { Typeahead } from 'react-bootstrap-typeahead'
import { PcIcon } from '../ui'

// TODO: get options from api
const options = [
  { id: 1, label: 'Decision Platform' },
  { id: 2, label: 'Professional Services' },
  { id: 3, label: 'Forecasting' },
  { id: 4, label: 'Other' },
]
export const MultiSelectDropdown = ({ id, label = 'Select items', hasIcon = true }) => {
  const [selected, setSelected] = useState([])
  const [dropdownOpen, setDropdownOpen] = useState(false)
  const typeaheadRef = useRef()
  const [isMenuOpen, setIsMenuOpen] = useState(false)

  const handleFocus = () => setDropdownOpen(true)
  const handleBlur = () => setDropdownOpen(false)
  const handleOnClickOutside = (e) => {
    
    const container = typeaheadRef.current?.container
    if (container && !container.contains(e.target)) {
      setDropdownOpen(false)
    }
  }

  useEffect(() => {
    document.addEventListener('click', handleOnClickOutside)
    return () => {
      document.removeEventListener('click', handleOnClickOutside)
    }
  }, [])

  return (
    <div className={'multi-select-dropdown'}>
      <Form.Group controlId={id} className="position-relative">
        <Typeahead
          id={'items-pricing-typeahead'}
          labelKey={'label'}
          onChange={setSelected}
          options={options}
          selected={selected}
          placeholder={'Make a selection'}
          multiple
          ref={typeaheadRef}
          open={dropdownOpen}
          onFocus={handleFocus}
          onBlur={handleBlur}
          onMenuToggle={(isOpen) => setIsMenuOpen(isOpen)}
          renderMenuItemChildren={(option, { onChange, selected }) => (
            <Form.Check
              type={'checkbox'}
              label={option.label}
              checked={selected}
              onChange={() => {
                const newSelection = selected ? selected.filter((item) => item.id !== option.id) : [...selected, option]
                setSelected((newSelection))
              }}
            />
          )}
        />
        <Form.Label className="pc-label fw-bold fs-10 lh-lg px-1" column={true}>{label}</Form.Label>
        {hasIcon && (
          <div className="position-absolute end-0 top-50 translate-middle-y pe-3">
            <PcIcon
              name={isMenuOpen ? 'arrow_up' : 'arrow_down'}
              alt={isMenuOpen ? 'Arrow pointing up' : 'Arrow pointing down'}
            />
          </div>
        )}
      </Form.Group>
    </div>
  )
}
