import React, { useState } from 'react'
import { Accordion } from 'react-bootstrap'
import { PcBtnAddRemoveNotes } from './PcBtnAddRemoveNotes'
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
    <Accordion flush activeKey={isOpen ? ['0'] : []} bsPrefix>
      <Accordion.Item eventKey="0" className={'pc-accordion-quote'}>
        <Accordion.Header onClick={onToggle} className={'mb-3'}>
          <div className={'d-flex align-items-center justify-content-between w-100'}>
            <span className="fs-10 fw-medium lh-lg text-gray-750 p-0">{itemName}</span>
            <div className="d-flex gap-4 align-items-center">
              {!isOpen && <div className="fs-10 text-secondary">{`$ ${quotePrice}`}</div>}
              {isOpen && (
                <>
                  <PcBtnAddRemoveNotes title={'Add item'} />
                  <PcBtnAddRemoveNotes title={'Remove item'} disabled={true} />
                </>)
              }
              <PcBtnAddRemoveNotes title={'Notes'} iconName={notesIcon} onClick={handleNotesShow} />
              <PcIcon
                name={isOpen ? 'accordionArrowUp' : 'accordionArrowDown'}
                alt={isOpen ? 'Arrow pointing up' : 'Arrow pointing down'}
                className={'ms-4'}
              />
            </div>
          </div>
        </Accordion.Header>
        <Accordion.Body>
          {children}
          <hr className={'pc-hr-divider w-100 mt-9'} />
        </Accordion.Body>
      </Accordion.Item>
    </Accordion>
  )
}
