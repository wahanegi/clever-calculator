import React, { useState } from 'react'
import { Button, Container } from 'react-bootstrap'
import { useAppHooks } from '../hooks'
import { ItemsPricingTopBar, QuoteCreation, ROUTES } from '../shared'
import { PcAccordion } from '../ui'
import { getCurrentStepId } from '../utils'

export const ItemsPricing = () => {
  const { navigate, queryParams, location } = useAppHooks()
  const quoteId = queryParams.get('quote_id')
  const currentStepId = getCurrentStepId(location.pathname)
  const totalPrice = 123 // TODO: get total price from BE

  const [selectedCategories, setSelectedCategories] = useState([])
  const [expandedAccordions, setExpandedAccordions] = useState([]) // array of IDs

  const handleToggle = (id) => {
    setExpandedAccordions((prev) =>
      prev.includes(id) ? prev.filter(item => item !== id) : [...prev, id],
    )
  }

  const expandAll = () => {
    setExpandedAccordions(selectedCategories.map(category => category.id))
  }

  const collapseAll = () => {
    setExpandedAccordions([])
  }

  const handleDownload = () => {
    // await fetchQuotes.update(quoteId, {
    //   quote: { step: STEPS.COMPLETED },
    // })
  }

  const handleBack = () => {
    navigate(ROUTES.CUSTOMER_INFO)
  }

  return (
    <Container className={'wrapper'}>
      <QuoteCreation currentStepId={currentStepId} />

      {/* Items & Pricing dashboard*/}
      <section className={'mb-8'}>
        <ItemsPricingTopBar
          totalPrice={totalPrice}
          selectedCategories={selectedCategories}
          setSelectedCategories={setSelectedCategories}
          expandAll={expandAll}
          collapseAll={collapseAll}
          expandedAccordions={expandedAccordions}
        />

        {selectedCategories.length === 0 &&
          (<div className="text-center text-muted py-5">
            Select one or more items to start your quote.
          </div>)
        }

        <div className={'d-flex flex-column gap-4'}>
          {selectedCategories.length > 0 && selectedCategories.map((category) => (
            <PcAccordion
              key={category.id}
              categoryName={category.label}
              isOpen={expandedAccordions.includes(category.id)}
              onToggle={() => handleToggle(category.id)}
            />
          ))}
        </div>
      </section>

      {/* Buttons section */}
      <section className={'d-flex justify-content-center align-items-center gap-4 mb-5'}>
        <Button variant={'outline-primary'} className={'fw-bold pc-btn-back'} onClick={handleBack}>Back</Button>
        <Button variant={'outline-primary'} className={'fw-bold pc-btn-download'} onClick={handleDownload}
                disabled={true}>Download</Button>
      </section>
    </Container>
  )
}
