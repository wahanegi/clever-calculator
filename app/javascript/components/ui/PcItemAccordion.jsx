import React, { useState } from 'react'
import { Accordion } from 'react-bootstrap'
import { PcExtraActionBtn } from './PcExtraActionBtn'
import { PcIcon } from './PcIcon'
import { fetchQuoteItems } from '../services'
import { formatCurrency } from '../utils'

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
      const clonedQuoteItem = data.data

      setSelectedOptions(prev => {
        const categoryId = clonedQuoteItem.attributes?.item?.category_id

        return prev.map(option => {
          if (isTarget(option, item, categoryId)) {
            const index = option.quote_items.findIndex((qi) => qi.id === item.id)
            if (index === -1) return option

            const newQuoteItems = [...option.quote_items]
            newQuoteItems.splice(index + 1, 0, clonedQuoteItem) // Insert after the current item

            return {
              ...option,
              quote_items: newQuoteItems,
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
            const quoteItems = option.quote_items.filter((quoteItem) => quoteItem.id !== item.id)

            if (quoteItems.length > 0) {
              return {
                ...option,
                quote_items: quoteItems,
              }
            } else {
              return null
            }
          }

          return option
        }).filter((option) => option !== null)
      })

    })
  }

  const PriceDisplay = () => <div className="fs-10 text-secondary">{formatCurrency(quotePrice)}</div>
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
