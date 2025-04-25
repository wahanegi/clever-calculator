import React, { useEffect, useRef, useState } from 'react'
import { Button, Form } from 'react-bootstrap'
import { Typeahead } from 'react-bootstrap-typeahead'
import { fetchCategories } from '../services'
import { PcCheckboxOption, PcIcon } from '../ui'
import { getRemovedCategory, normalizeApiCategories } from '../utils'

export const MultiSelectDropdown = ({
  id,
  label = 'Select items',
  hasIcon = true,
  selected,
  setSelected,
  showDeleteModal,
}) => {
  const typeaheadRef = useRef()
  const [categories, setCategories] = useState([])
  const [isMenuOpen, setIsMenuOpen] = useState(false)

  const toggleMenu = (e) => {
    e.stopPropagation()
    setIsMenuOpen(prev => !prev)
  }
  const handleFocus = () => setIsMenuOpen(true)
  const handleBlur = () => setIsMenuOpen(false)

  const handleMenuOpen = (isOpen) => setIsMenuOpen(isOpen)
  const isSelected = (option) => selected.some(item => item.id === option.id)
  const toggleSelection = (option) => {
    // Remove the option from selected array
    if (isSelected(option)) {
      showDeleteModal(option.id)
    } else {
      // Add the option to selected array
      setSelected([...selected, option])
    }
  }

  const handleTypeaheadOnChange = (newSelected) => {
    if (newSelected.length < selected.length) {
      const removedCategory = getRemovedCategory(selected, newSelected)

      if (removedCategory) {
        return showDeleteModal(removedCategory.id)
      }
    }
    setSelected(newSelected)
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
          onChange={handleTypeaheadOnChange}
          onFocus={handleFocus}
          onBlur={handleBlur}
          onMenuToggle={handleMenuOpen}
          open={isMenuOpen}
          multiple
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
          <div
            className={"position-absolute end-0 top-50 translate-middle-y z-2 me-4"}>
            <Button
              variant={'outline'}
              className={'p-0 border-0'}
              onClick={toggleMenu}
            >
              <PcIcon name={`${isMenuOpen ? 'arrowUpLight' : 'arrowDownLight'}`} />
            </Button>
          </div>
        )}
      </Form.Group>
    </div>
  )
}
