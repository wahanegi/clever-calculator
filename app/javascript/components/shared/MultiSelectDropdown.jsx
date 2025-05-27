import React, { useEffect, useRef, useState } from 'react'
import { Form } from 'react-bootstrap'
import { Typeahead } from 'react-bootstrap-typeahead'
import { PcCheckboxOption, PcIcon, PcTransparentButton } from '../ui'

export const MultiSelectDropdown = ({
                                      id,
                                      label = 'Select Categories & Items',
                                      hasIcon = true,
                                      selectedOptions,
                                      selectableOptions,
                                      onChange,
                                      isSelected,
                                    }) => {
  const [isMenuOpen, setIsMenuOpen] = useState(false)

  const typeaheadRef = useRef(null)

  useEffect(() => {
    const inputWrapper = document.querySelector('div.rbt-input-wrapper')

    if (!inputWrapper) return

    const onWheel = (e) => {
      const deltaY = e.deltaY
      if (deltaY !== 0) {
        e.preventDefault()
        inputWrapper.scrollLeft += deltaY
      }
    }

    inputWrapper.addEventListener('wheel', onWheel, { passive: false })

    return () => {
      inputWrapper.removeEventListener('wheel', onWheel)
    }
  }, [])

  const handleBlur = () => setIsMenuOpen(false)

  const handleMenuOpen = (e) => {
    if (!isMenuOpen) typeaheadRef.current.focus()
    setIsMenuOpen((prev) => !prev)
  }

  const handleClick = () => {
    if (!isMenuOpen) {
      setIsMenuOpen(true)
      typeaheadRef.current.focus()
    }
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
        onChange={onChange}
        onBlur={handleBlur}
        open={isMenuOpen}
        allowNew={false}
        multiple
        className={'pc-typeahead-items-pricing'}
        renderMenuItemChildren={(option, props) => {
          const query = props.text || ''
          const regex = new RegExp(`(${query})`, 'gi')
          const highlightedLabel = option.name.replace(regex, '<span class="rbt-highlight-text">$1</span>')

          return (
            <PcCheckboxOption
              label={<span dangerouslySetInnerHTML={{ __html: highlightedLabel }} />}
              checked={isSelected(option)}
              onChange={() => {}}
              className={'pc-checkbox-items-pricing'}
            />
          )
        }}
        // Custom render for selected tokens to make them removable 
        renderToken={(option, props, index) => (
          <div
            key={index}
            className="rbt-token rbt-token-removeable"
            tabIndex={0}
            onClick={(e) => {
              e.stopPropagation()
              const updated = selectedOptions.filter(
                (selected) => selected.id !== option.id || selected.type !== option.type,
              )
              onChange(updated)
            }}
          >
            <div className="rbt-token-label">{option.name}</div>
            <button
              tabIndex={-1}
              aria-label="Remove"
              className="close btn-close rbt-close rbt-token-remove-button"
              type="button"
              onClick={(e) => {
                e.stopPropagation()
                const updated = selectedOptions.filter(
                  (selected) => selected.id !== option.id || selected.type !== option.type,
                )
                onChange(updated)
              }}
            >
              <span aria-hidden="true" className="rbt-close-content">
                X
              </span>
              <span className="sr-only visually-hidden">Remove</span>
            </button>
          </div>
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
