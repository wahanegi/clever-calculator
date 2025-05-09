import React, { useState } from 'react'
import { Accordion } from 'react-bootstrap'
import { PcExtraActionBtn } from './PcExtraActionBtn'
import { PcIcon } from './PcIcon'

export const PcItemAccordion = ({
                                  children,
                                  itemName = 'Item name',
                                  quotePrice = '0',
                                  onToggleNotes,
                                  notesIcon,
                                }) => {
  const [isOpen, setIsOpen] = useState(true)

  const handleToggle = () => setIsOpen(!isOpen)

  const PriceDisplay = () => <div className="fs-10 text-secondary">{`$ ${quotePrice}`}</div>
  const Toolbar = () => <>
    <PcExtraActionBtn children={'Add item'} />
    <PcExtraActionBtn children={'Remove item'} disabled={true} />
  </>

  return (
    <Accordion flush activeKey={isOpen ? ['0'] : []} bsPrefix={'pc-item-accordion'}>
      <Accordion.Item eventKey="0">
        <div className={'position-relative'}>
          <Accordion.Header onClick={handleToggle} className={'position-relative z-0 mb-3 pb-8 pb-sm-0'}>
            <div className={'d-flex align-items-center justify-content-between w-100'}>
              <span className="pc-item-name fs-10 fw-medium lh-lg text-gray-750 p-0 text-truncate">{itemName}</span>
              <div className="d-flex gap-4 align-items-center">
                <PcIcon
                  name={isOpen ? 'accordionArrowUp' : 'accordionArrowDown'}
                  alt={isOpen ? 'Arrow pointing up' : 'Arrow pointing down'}
                  className={'ms-4'}
                />
              </div>
            </div>
          </Accordion.Header>

          <div
            className="pc-extra-actions position-absolute top-50 translate-middle-y d-flex align-items-center gap-2 gap-sm-5 z-1">
            {isOpen ? <Toolbar /> : <PriceDisplay />}
            <PcExtraActionBtn iconName={notesIcon} children={'Notes'} onClick={onToggleNotes} />
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
