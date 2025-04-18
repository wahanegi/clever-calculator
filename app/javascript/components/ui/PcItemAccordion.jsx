import React, { useState } from 'react'
import { Accordion } from 'react-bootstrap'
import { PcExtraActionBtn } from './PcExtraActionBtn'
import { PcIcon } from './PcIcon'

export const PcItemAccordion = ({
  children,
  itemName = 'Item name',
  quotePrice = '0',
  // isOpen = true,
  // onToggle,
  isNotesShow,
  setIsNotesShow,
  notesIcon,
}) => {

  const [isOpen, setIsOpen] = useState(true) //TODO: will be deleted after adding logic
  const onToggle = () => setIsOpen(!isOpen) //TODO: will be deleted after adding logic

  const handleNotesShow = () => {
    setIsNotesShow(!isNotesShow)
  }

  return (
    <Accordion flush activeKey={isOpen ? ['0'] : []} bsPrefix={'pc-item-accordion'}>
      {/*<Accordion.Item eventKey="0" className={'pc-accordion-quote'}>*/}
      <Accordion.Item eventKey="0">
        <div className={'position-relative'}>
          <Accordion.Header onClick={onToggle} className={'position-relative z-0 mb-3'}>
            <div className={'d-flex align-items-center justify-content-between w-100'}>
              <span className="fs-10 fw-medium lh-lg text-gray-750 p-0">{itemName}</span>
              <div className="d-flex gap-4 align-items-center">
                <PcIcon
                  name={isOpen ? 'accordionArrowUp' : 'accordionArrowDown'}
                  alt={isOpen ? 'Arrow pointing up' : 'Arrow pointing down'}
                  className={'ms-4'}
                />
              </div>

            </div>
          </Accordion.Header>

          {/*Extra Accordion.Header elements. For involve button hydration error*/}
          <div
            className="pc-extra-actions position-absolute top-50 translate-middle-y d-flex align-items-center gap-5 z-1">
            {!isOpen && <div className="fs-10 text-secondary">{`$ ${quotePrice}`}</div>}
            {isOpen && (
              <>
                <PcExtraActionBtn children={'Add item'} />
                <PcExtraActionBtn children={'Remove item'} disabled={true} />
              </>)
            }
            <PcExtraActionBtn iconName={notesIcon} children={'Notes'} onClick={handleNotesShow} />
          </div>
        </div>

        <Accordion.Body>
          {children}
          <hr className={'pc-hr-divider w-100 mt-14'} />
        </Accordion.Body>
      </Accordion.Item>
    </Accordion>
  )
}
