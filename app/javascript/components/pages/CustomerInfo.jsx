import React from 'react'
import { Container, Row } from 'react-bootstrap'
import { useAppHooks } from '../hooks'
import { fetchQuotes } from '../services'
import { ROUTES, STEPS } from '../shared'
import { PcButton } from '../ui'

export const CustomerInfo = () => {
  const { navigate } = useAppHooks()
  const handleNext = async () => {
    //TODO Hardcode customer_id for now (replace with real logic later)
    const customerId = 3
    const { data } = await fetchQuotes.create({
      quote: {
        customer_id: customerId,
        total_price: 0,
        step: STEPS.ITEM_PRICING,
      },
    })

    navigate(`${ROUTES.ITEM_PRICING}?quote_id=${data.id}`)
  }

  return (
    <Container className={'wrapper'}>
      {/* Title & progress bar */}
      <section className={'px-6 mb-2'}>
        <div className={'d-flex justify-content-between mb-6'}>
          <h1>Quote Creation</h1>
        </div>
        <div style={{ height: '79px', border: '2px solid red' }}>
          <span>Progress bar</span>
        </div>
      </section>

      {/* Customer Information dashboard*/}
      <section className={'mb-8'}>
        <h2 className={'text-center mb-7'}>Customer Information</h2>
        <Row>
          <div style={{ height: '387px', border: '2px solid red' }}></div>
        </Row>
      </section>

      <section className={'d-flex justify-content-center align-items-center gap-4 mb-5'}>
        <PcButton variant={'primary'} children={'Next'} onClick={handleNext} />
      </section>
    </Container>
  )
}
