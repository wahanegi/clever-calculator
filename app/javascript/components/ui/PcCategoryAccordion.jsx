import React from 'react'
import { Accordion, Button } from 'react-bootstrap'
import { PcIcon } from './PcIcon'

export const PcCategoryAccordion = ({
  children,
  categoryName = 'Category Name',
  categoryPrice = '0',
  isOpen,
  onToggle,
  onDelete,
}) => {
  const handleOpenModal = (e) => {
    e.stopPropagation()
    onDelete()
  }

  return (
    <>
      <Accordion flush activeKey={isOpen ? ['0'] : []} bsPrefix={'pc-category-accordion'}>
        <Accordion.Item eventKey="0">
          <div className={'position-relative'}>
            <Accordion.Header onClick={onToggle} className="position-relative z-0">
              <div className="d-flex justify-content-between align-items-center w-100">
                <div className="fw-bold fs-9 lh-base text-dark ps-2 text-truncate pe-17">{categoryName}</div>
                <PcIcon
                  name={isOpen ? 'accordionArrowUp' : 'accordionArrowDown'}
                  alt={isOpen ? 'Arrow pointing up' : 'Arrow pointing down'}
                />
              </div>
            </Accordion.Header>

            {/*Extra Accordion.Header elements. For involve button hydration error*/}
            <div
              className="pc-extra-actions position-absolute top-50 translate-middle-y d-flex align-items-center gap-5 z-1">
              <div className="fs-10 text-secondary fw-medium">{`$ ${categoryPrice}`}</div>

              <Button variant={'outline'} className={'pc-icon-hover-btn'} onClick={handleOpenModal}>
                <PcIcon name={'trashDefault'} className="icon-default" />
                <PcIcon name={'trashDanger'} className="icon-hover" />
              </Button>
            </div>
          </div>

          <Accordion.Body className="border border-primary border-top-0 bg-white rounded-bottom-2">
            <div className={'px-8 py-5'}>
              {children}
            </div>
            <div className="accordion-bottom-filling bg-light rounded-bottom-2" />
          </Accordion.Body>
        </Accordion.Item>
      </Accordion>
    </>
  )
}
