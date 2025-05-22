import React, { useEffect, useRef, useState } from 'react'
import { Form } from 'react-bootstrap'
import { Typeahead } from 'react-bootstrap-typeahead'
import { PcCheckboxOption, PcIcon, PcTransparentButton } from '../ui'

export const MultiSelectDropdown = ({
                                      id,
                                      label = 'Select items',
                                      hasIcon = true,
                                      selectedOptions,
                                      selectableOptions,
                                      onChange,
                                      isSelected,
                                    }) => {
  const [isMenuOpen, setIsMenuOpen] = useState(false)

  const typeaheadRef = useRef(null)

  useEffect(() => {
    const inputWrapper = document.querySelector('div.rbt-input-wrapper');

    if (!inputWrapper) return;

    const onWheel = (e) => {
      e.preventDefault();
      inputWrapper.scrollBy({ left: e.deltaY, behavior: 'smooth' });
    };

    inputWrapper.addEventListener('wheel', onWheel, { passive: false });

    return () => {
      inputWrapper.removeEventListener('wheel', onWheel);
    };
  }, []);

  const handleBlur = () => setIsMenuOpen(false)

  const handleMenuOpen = (e) => {
    if (!isMenuOpen) typeaheadRef.current.focus()
    setIsMenuOpen((prev) => !prev)
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
        selected={selectedOptions}
        options={selectableOptions}
        filterBy={() => true} // set array of options with no changes
        onChange={onChange}
        onBlur={handleBlur}
        open={isMenuOpen}
        multiple
        className={'pc-typeahead-items-pricing'}
        renderMenuItemChildren={(option) => (
          <PcCheckboxOption
            label={option.name}
            checked={isSelected(option)}
            onChange={(e) => {}}
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
