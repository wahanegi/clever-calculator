import React from 'react'
import { Accordion } from 'react-bootstrap'
import { PcIcon } from './PcIcon'

export const PcAccordion = ({ categoryName = 'Category Name', categoryPrice = '$ 0', isOpen, onToggle }) => {
  return (
    <Accordion flush activeKey={isOpen ? ['0'] : []} bsPrefix>
      <Accordion.Item eventKey="0">
        <Accordion.Header onClick={onToggle}>
          <div className="d-flex justify-content-between align-items-center w-100">
            <div className="fw-bold fs-9 lh-base text-dark ps-2">{categoryName}</div>
            <div className="pe-8 fs-10 text-secondary">{categoryPrice}</div>
            <div className="position-absolute end-0 top-50 translate-middle-y pe-5">
              <PcIcon
                name={isOpen ? 'accordionArrowUp' : 'accordionArrowDown'}
                alt={isOpen ? 'Arrow pointing up' : 'Arrow pointing down'}
              />
            </div>
          </div>
        </Accordion.Header>
        <Accordion.Body className="border border-primary border-top-0 bg-white rounded-bottom-2">
          {/* Category content */}
          <div className="pc-accordion-body">
            Content for <strong>{categoryName}</strong>
          </div>
          <div className="accordion-bottom-filling bg-light rounded-bottom-2" />
        </Accordion.Body>
      </Accordion.Item>
    </Accordion>
  )
}
