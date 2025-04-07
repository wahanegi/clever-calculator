import React, { useState } from 'react'
import { Accordion } from 'react-bootstrap'
import { PcIcon } from './PcIcon'

export const PcAccordion = ({ categoryName = 'Category Name', categoryPrice = '$ 0' }) => {
  const [isOpen, setIsOpen] = useState(false)

  return (
    <Accordion flush>
      <Accordion.Item eventKey="0">
        <Accordion.Header onClick={() => setIsOpen(!isOpen)}>
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
        <Accordion.Body>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore
          magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
          consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
          pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id
          est laborum.
        </Accordion.Body>
      </Accordion.Item>
    </Accordion>
  )
}
