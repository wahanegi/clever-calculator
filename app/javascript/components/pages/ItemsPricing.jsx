import React from 'react'
import { Button, Container, Row } from 'react-bootstrap'
import { useAppHooks } from '../hooks'
import { fetchQuotes } from '../services'
import { QuoteCreation, ROUTES, STEPS } from '../shared'
import { getCurrentStepId } from '../utils';

export const ItemsPricing = () => {
  const { navigate, queryParams, location} = useAppHooks()
  const quoteId = queryParams.get('quote_id')
  const currentStepId = getCurrentStepId(location.pathname)

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
        <Row>
          <div style={{ height: '180px', border: '2px solid red' }}></div>
        </Row>
      </section>

      {/* Buttons section */}
      <section className={'d-flex justify-content-center align-items-center gap-4 mb-5'}>
        <Button variant={'outline-primary'} className={'fw-bold pc-btn-back'} onClick={handleBack}>Back</Button>
        <Button variant={'outline-primary'} className={'fw-bold pc-btn-download'} onClick={handleDownload} disabled={true}>Download</Button>
      </section>
    </Container>
  )
}
