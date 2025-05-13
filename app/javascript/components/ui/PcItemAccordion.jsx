import React, { useState } from 'react'
import { Accordion } from 'react-bootstrap'
import { PcExtraActionBtn } from './PcExtraActionBtn'
import { PcIcon } from './PcIcon'
import { fetchQuoteItems } from '../services'

export const PcItemAccordion = ({
                                  children,
                                  onToggleNotes,
                                  notesIcon,
                                  item,
                                  quoteId,
                                  setSelectedOptions,
                                }) => {
  const [isOpen, setIsOpen] = useState(true)

  const itemName = item.attributes.item.name
  const quotePrice = item.attributes.final_price

  const isTarget = (option, quoteItem, categoryId) =>
    option.id === (categoryId ?? quoteItem.attributes.item.id) &&
    option.type === (categoryId ? 'category' : 'item')

  const handleToggle = () => setIsOpen(!isOpen)

  const handleItemAdd = () => {
    fetchQuoteItems.duplicateOne(quoteId, item.id).then((data) => {
      const cloneQuoteItem = data.data

      setSelectedOptions(prev => {
        const categoryId = cloneQuoteItem.attributes?.item?.category_id

        return prev.map(option => {
          if (isTarget(option, item, categoryId)) {
            return {
              ...option,
              quote_items: [...option.quote_items, cloneQuoteItem],
            }
          }

          return option
        })
      })

    })
  }

  const handleItemRemove = () => {
    fetchQuoteItems.deleteSelected(quoteId, [item.id]).then(() => {
      setSelectedOptions(prev => {
        const categoryId = item.attributes?.item?.category_id

        return prev.map(option => {
          if (isTarget(option, item, categoryId)) {
            return {
              ...option,
              quote_items: option.quote_items.filter((quoteItem) => quoteItem.id !== item.id),
            }
          }

          return option
        })
      })
    })
  }

  const PriceDisplay = () => <div className="fs-10 text-secondary">{`$ ${quotePrice}`}</div>
  const Toolbar = () => <>
    <PcExtraActionBtn children={'Add item'} onClick={handleItemAdd} />
    <PcExtraActionBtn children={'Remove item'} onClick={handleItemRemove} />
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
