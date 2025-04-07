import React, { useState } from 'react'
import { Button, Container } from 'react-bootstrap'
import { useAppHooks } from '../hooks'
import { fetchQuotes } from '../services'
import { QuoteCreation, ROUTES, STEPS } from '../shared'
import { ItemsPricingTopBar } from '../shared/ItemsPricingTopBar'
import { PcAccordion } from '../ui'
import { getCurrentStepId } from '../utils'

export const ItemsPricing = () => {
  const { navigate, queryParams } = useAppHooks()
  const quoteId = queryParams.get('quote_id')
  const currentStepId = getCurrentStepId(location.pathname)
  const totalPrice = 123 // TODO: get total price from BE

  const [isExpended, setIsExpended] = useState(false)

  const handleToggle = () => {
    setIsExpended((prev) => !prev)
    // TODO: add logic for accordion
  }

  const handleDownload = async () => {
    await fetchQuotes.update(quoteId, {
      quote: { step: STEPS.COMPLETED },
    })
  }

  const handleBack = () => {
    navigate(ROUTES.CUSTOMER_INFO)
  }

  return (
    <Container className={'wrapper'}>
      <QuoteCreation currentStepId={currentStepId} />

      {/* Items & Pricing dashboard*/}
      <section className={'mb-8'}>
        <ItemsPricingTopBar totalPrice={totalPrice} isExpended={isExpended} handleToggle={handleToggle} />
        <PcAccordion />
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
