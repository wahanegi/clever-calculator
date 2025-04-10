import React, { useEffect, useRef, useState } from 'react'
import { Form } from 'react-bootstrap'
import { Typeahead } from 'react-bootstrap-typeahead'
import { fetchCategories } from '../services'
import { PcCheckboxOption, PcIcon } from '../ui'
import { normalizeApiCategories } from '../utils'

export const MultiSelectDropdown = ({
  id,
  label = 'Select items',
  hasIcon = true,
  selected,
  setSelected,
}) => {
  const [dropdownOpen, setDropdownOpen] = useState(false)
  const [isMenuOpen, setIsMenuOpen] = useState(false)
  const [categories, setCategories] = useState([])
  const typeaheadRef = useRef()

  const handleFocus = () => setDropdownOpen(true)
  const handleBlur = () => setDropdownOpen(false)

  const handleMenuOpen = (isOpen) => setIsMenuOpen(isOpen)
  const isSelected = (option) => selected.some(item => item.id === option.id)
  const toggleSelection = (option) => {
    // Remove the option from selected array
    if (isSelected(option)) {
      setSelected(selected.filter(item => item.id !== option.id))
    } else {
      // Add the option to selected array
      setSelected([...selected, option])
    }
  }

  useEffect(() => {
    fetchCategories.index().then(res => {
      const categories = normalizeApiCategories(res.data)
      setCategories(categories)
    })
  }, [])

  return (
    <div className={'multi-select-dropdown'}>
      <Form.Group controlId={id} className="position-relative">
        <Typeahead
          id={'items-pricing-typeahead'}
          labelKey={'name'}
          placeholder={'Make a selection'}
          ref={typeaheadRef}
          selected={selected}
          options={categories} // use with filterBy
          filterBy={() => true} // set array of options with no changes
          onChange={setSelected}
          onFocus={handleFocus}
          onBlur={handleBlur}
          open={dropdownOpen}
          multiple
          onMenuToggle={handleMenuOpen}
          className={'pc-typeahead-items-pricing'}
          renderMenuItemChildren={(option) => (
            <PcCheckboxOption
              option={option}
              isSelected={isSelected}
              toggleSelection={toggleSelection}
              className={'pc-checkbox-items-pricing'}
            />
          )}
        />

        <Form.Label className="pc-label position-absolute fw-bold fs-10 lh-lg m-0 py-0 px-1" column={true}>
          {label}
        </Form.Label>

        {hasIcon && (
          <div className="position-absolute end-0 top-50 translate-middle-y pe-3">
            <PcIcon
              name={isMenuOpen ? 'arrowUp' : 'arrowDown'}
              alt={isMenuOpen ? 'Arrow pointing up' : 'Arrow pointing down'}
            />
          </div>
        )}
      </Form.Group>
    </div>
  )
}
