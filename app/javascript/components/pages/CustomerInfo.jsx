import React from 'react'
import { Container, Row } from 'react-bootstrap'
import { useNavigate } from 'react-router-dom'
import { ROUTES } from '../shared'
import { PcButton } from '../ui'
import { fetchQuotes } from '../services/fetchService'

export const CustomerInfo = () => {
  const navigate = useNavigate()

  const handleNext = async () => {
    try {
      //TODO Hardcode customer_id for now (replace with real logic later)
      const customerId = 3
      const response = await fetchQuotes.create({
        quote: {
          customer_id: customerId,
          total_price: 0,
          step: 'items_pricing',
        },
      })
      const { data } = response.data
      const quoteId = data.id
      navigate(`${ROUTES.ITEM_PRICING}?quote_id=${quoteId}`)
    } catch (error) {
      console.error('Error creating quote:', error)
    }
  }

  return (
    <Container className={'wrapper'}>
      {/* Title & progress bar */}
      <section className={'px-6 mb-2'}>
        <div className={'d-flex justify-content-between mb-6'}>
          <h1>Quote Creation</h1>
          <PcButton variant={'outline-primary'} children={'Reset'} className={'mt-2'} />
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
        <PcButton variant={'outline-primary'} children={'Next'} onClick={handleNext} />
      </section>
    </Container>
  )
}
