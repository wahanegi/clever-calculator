import React, { useRef, useState } from 'react'
import { Form } from 'react-bootstrap'
import { Typeahead } from 'react-bootstrap-typeahead'
import { PcCheckboxOption, PcIcon, PcTransparentButton } from '../ui'
import { getRemovedCategory } from '../utils'

export const MultiSelectDropdown = ({
  id,
  label = 'Select items',
  hasIcon = true,
  selected,
  setSelected,
  showDeleteModal,
  selectableOptions,
}) => {
  const [isMenuOpen, setIsMenuOpen] = useState(false)

  const typeaheadRef = useRef(null)

  const isSelected = (option) => selected.some((item) => item.id === option.id)

  const toggleSelection = (option) => {
    // Remove the option from selected array
    if (isSelected(option)) {
      showDeleteModal(option.id)
    } else {
      // Add the option to selected array
      setSelected([...selected, option])
    }
  }

  const handleBlur = () => setIsMenuOpen(false)

  const handleMenuOpen = (e) => {
    if (!isMenuOpen) typeaheadRef.current.focus()
    setIsMenuOpen((prev) => !prev)
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

  const handleClick = () => {
    setIsMenuOpen(!isMenuOpen)
  }

  const TypeaheadControls = () => (
    <div className={'multi-select-dropdown-controls position-absolute end-0 top-0 h-100'}>
      <PcTransparentButton onClick={handleMenuOpen} className={'h-100 w-100'}>
        <PcIcon name={`${isMenuOpen ? 'arrowUpLight' : 'arrowDownLight'}`} />
      </PcTransparentButton>
    </div>
  )

  return (
    <Form.Group controlId={id} className="multi-select-dropdown w-100 position-relative">
      <Typeahead
        id={'items-pricing-typeahead'}
        labelKey={'name'}
        placeholder={'Make a selection'}
        ref={typeaheadRef}
        selected={selected}
        options={selectableOptions}
        filterBy={() => true} // set array of options with no changes
        onChange={handleTypeaheadOnChange}
        onBlur={handleBlur}
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
        inputProps={{ onClick: handleClick }}
      />

      <Form.Label className="pc-label position-absolute fw-bold fs-10 lh-lg m-0 py-0 px-1" column={true}>
        {label}
      </Form.Label>

      {hasIcon && <TypeaheadControls />}
    </Form.Group>
  )
}
