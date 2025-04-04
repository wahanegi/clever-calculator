import React from 'react'
import { Container, Row, Button } from 'react-bootstrap'
import { useAppHooks } from '../hooks'
import { fetchQuotes } from '../services'
import { QuoteCreation, ROUTES, STEPS } from '../shared'
import { getCurrentStepId } from '../utils';

export const CustomerInfo = () => {
  const { navigate, location } = useAppHooks()
  const currentStepId = getCurrentStepId(location.pathname)

  // const handleNext = async () => {
  //   //TODO Hardcode customer_id for now (replace with real logic later)
  //   const customerId = 3
  //   const { data } = await fetchQuotes.create({
  //     quote: {
  //       customer_id: customerId,
  //       total_price: 0,
  //       step: STEPS.ITEM_PRICING,
  //     },
  //   })
  //
  //   navigate(`${ROUTES.ITEM_PRICING}?quote_id=${data.id}`)
  // }

  // Remove it when you need to create a quote
  const handleNext = () => {
    navigate(ROUTES.ITEM_PRICING)
  }

  return (
    <Container className={'wrapper'}>
      <QuoteCreation currentStepId={currentStepId} isBtnShow={false} />

      {/* Customer Information dashboard*/}
      <section className={'mb-8'}>
        <Row>
          <div style={{ height: '387px', border: '2px solid red' }}></div>
        </Row>
      </section>

      <section className={'d-flex justify-content-center align-items-center gap-4 mb-5'}>
        <Button onClick={handleNext} className={'pc-btn-next'}>Next</Button>
      </section>
    </Container>
  )
}
